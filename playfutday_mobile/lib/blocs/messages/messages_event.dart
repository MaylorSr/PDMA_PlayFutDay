import 'package:equatable/equatable.dart';

abstract class AllMessagesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllMessagesFetched extends AllMessagesEvent {}

class RefreshMessages extends AllMessagesEvent {
  final String body;
  final String uuid;

  RefreshMessages(this.body, this.uuid);
}

class OnDeleteMessage extends AllMessagesEvent {
  final int idMessage;

  OnDeleteMessage(this.idMessage);
}
