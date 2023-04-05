import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/follows/follow.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/user_service/user_service.dart';
import 'follow_event.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FollowBloc extends Bloc<AllFollowEvent, AllFollowState> {
  FollowBloc(this._userService, this.uuid) : super(const AllFollowState()) {
    on<AllFollowFetched>(
      _onAllFollowFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<AddFollowFetched>(addFollow,
        transformer: throttleDroppable(throttleDuration));
  }

  final UserService _userService;
  final String uuid;

  Future<void> _onAllFollowFetched(
      AllFollowFetched event, Emitter<AllFollowState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllFollowStatus.initial) {
        page = 0;
        final allFollow = await _userService.getFollows(page, uuid);
        return emit(state.copyWith(
          status: AllFollowStatus.success,
          allFollow: allFollow!.userFollow,
          hasReachedMax: allFollow.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allFollow = await _userService.getFollows(page, uuid);

      emit(state.copyWith(
          status: AllFollowStatus.success,
          allFollow: List.of(state.allFollow)..addAll(allFollow!.userFollow),
          hasReachedMax: allFollow.totalPages - 1 <= page));
    } catch (_) {
      emit(state.copyWith(status: AllFollowStatus.failure));
    }
  }

  getTotalElements() async {
    try {
      final totalFollows = await _userService.getFollows(0, uuid);
      return totalFollows!.totalElements;
    } catch (e) {
      return 0;
    }
  }

  Future<void> addFollow(
      AddFollowFetched event, Emitter<AllFollowState> emit) async {
    await _userService.addFollow(event.id);

    return emit(state.copyWith(status: AllFollowStatus.success));
  }

  addF(String id) async {
    await _userService.addFollow(id);
  }
}
