import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/user_service/user_service.dart';
import 'follower_event.dart';
import 'follower_state.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FollowerBloc extends Bloc<AllFollowerEvent, AllFollowerState> {
  FollowerBloc(this._userService, this.uuid) : super(const AllFollowerState()) {
    on<AllFollowerFetched>(
      _onAllFollowerFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final UserService _userService;
  final String uuid;

  Future<void> _onAllFollowerFetched(
      AllFollowerFetched event, Emitter<AllFollowerState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllFollowerStatus.initial) {
        page = 0;
        final allFollower = await _userService.getFollowers(page, uuid);
        return emit(state.copyWith(
          status: AllFollowerStatus.success,
          allFollower: allFollower!.userFollow,
          hasReachedMax: allFollower.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allFollower = await _userService.getFollowers(page, uuid);

      emit(state.copyWith(
          status: AllFollowerStatus.success,
          allFollower: List.of(state.allFollower)
            ..addAll(allFollower!.userFollow),
          hasReachedMax: allFollower.totalPages - 1 <= page));
    } catch (_) {
      emit(state.copyWith(status: AllFollowerStatus.failure));
    }
  }

  getTotalElements() async {
    try {
      final totalFollowers = await _userService.getFollowers(0, uuid);
      return totalFollowers!.totalElements;
    } catch (e) {
      return 0;
    }
  }
}
