// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum AllMessagesStatus { initial, success, failure }

class AllMessagesState extends Equatable {
  const AllMessagesState({
    this.status = AllMessagesStatus.initial,
    this.allMessages = const <Message>[],
    this.hasReachedMax = false,
  });

  final AllMessagesStatus status;
  final List<Message> allMessages;
  final bool hasReachedMax;

  AllMessagesState copyWith({
    AllMessagesStatus? status,
    List<Message>? allMessages,
    bool? hasReachedMax,
  }) {
    return AllMessagesState(
      status: status ?? this.status,
      allMessages: allMessages ?? this.allMessages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AllMessagesState { status: $status, hasReachedMax: $hasReachedMax, allMessages: ${allMessages.length} }''';
  }

  @override
  List<Object> get props => [status, allMessages, hasReachedMax];
}