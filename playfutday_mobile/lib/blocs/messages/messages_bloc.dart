import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../services/user_service/user_service.dart';
import 'messages.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MessagesBloc extends Bloc<AllMessagesEvent, AllMessagesState> {
  MessagesBloc(this._userService, this.idUser)
      : super(const AllMessagesState()) {
    on<AllMessagesFetched>(
      _onAllMessagesFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<RefreshMessages>(
      _sendMessage,
      transformer: throttleDroppable(throttleDuration),
    );

    on<OnDeleteMessage>(
      _onDeleteMessage,
      transformer: throttleDroppable(throttleDuration),
    );
  }
  final UserService _userService;
  final String idUser;

  Future<void> _onAllMessagesFetched(
      AllMessagesFetched event, Emitter<AllMessagesState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllMessagesStatus.initial) {
        page = 0;
        final allMessages = await _userService.getMessagesByChat(idUser, page);
        return emitter(state.copyWith(
          status: AllMessagesStatus.success,
          allMessages: allMessages!.content,
          hasReachedMax: allMessages.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allMessages = await _userService.getMessagesByChat(idUser, page);

      emitter(state.copyWith(
          status: AllMessagesStatus.success,
          allMessages: List.of(state.allMessages)..addAll(allMessages!.content),
          hasReachedMax: allMessages.totalPages - 1 <= page));
    } catch (e) {
      emitter(state.copyWith(status: AllMessagesStatus.failure));
    }
  }

  Future<void> _sendMessage(
      RefreshMessages event, Emitter<AllMessagesState> emit) async {
    _userService.sendMessageToUser(event.body, event.uuid);

    emit(state.copyWith(
      status: AllMessagesStatus.initial,
      hasReachedMax: false,
    ));
    add(AllMessagesFetched());
  }

  Future<void> _onDeleteMessage(
      OnDeleteMessage event, Emitter<AllMessagesState> emitter) async {
    final deleteInProgress = state.allMessages.map((message) {
      // ignore: unrelated_type_equality_checks
      return message.id == event.idMessage ? state.copyWith() : message;
    }).toList();

    print(deleteInProgress);
    // ignore: invalid_use_of_visible_for_testing_member
    emitter(state.copyWith(
        status: AllMessagesStatus.success,
        allMessages: state.allMessages,
        hasReachedMax: false));

    unawaited(
      _userService.deleteMessage(event.idMessage).then((_) {
        final deleteSuccess = List.of(state.allMessages)
          // ignore: unrelated_type_equality_checks
          ..removeWhere((message) => message.id == event.idMessage);
        // ignore: invalid_use_of_visible_for_testing_member
        emitter(state.copyWith(allMessages: deleteSuccess));
      }),
    );
  }
}
