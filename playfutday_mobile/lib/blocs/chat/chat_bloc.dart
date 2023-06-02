import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/blocs.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../services/user_service/user_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ChatBloc extends Bloc<AllChatEvent, AllChatState> {
  ChatBloc(this._userService) : super(const AllChatState()) {
    on<AllChatFetched>(
      _onAllChatFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<OnRefreshChat>(_onRefreshChat);
  }
  final UserService _userService;

  Future<void> _onAllChatFetched(
      AllChatFetched event, Emitter<AllChatState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllChatStatus.initial) {
        page = 0;
        final allChat = await _userService.getMyChats(page);
        return emitter(state.copyWith(
          status: AllChatStatus.success,
          allChat: allChat!.content,
          hasReachedMax: allChat.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allChat = await _userService.getMyChats(page);

      emitter(
        state.copyWith(
            status: AllChatStatus.success,
            allChat: List.of(state.allChat)..addAll(allChat!.content),
            hasReachedMax: allChat.totalPages - 1 <= page),
      );
    } catch (e) {
      emitter(state.copyWith(status: AllChatStatus.failure));
    }
  }

  Future<void> _onRefreshChat(
      OnRefreshChat event, Emitter<AllChatState> emit) async {
    emit(state.copyWith(
      status: AllChatStatus.initial,
      hasReachedMax: false,
    ));

    add(AllChatFetched());
  }
}
