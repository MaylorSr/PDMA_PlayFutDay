// ignore: file_names
import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum AllChatStatus { initial, success, failure }

class AllChatState extends Equatable {
  const AllChatState({
    this.status = AllChatStatus.initial,
    this.allChat = const <Chat>[],
    this.hasReachedMax = false,
  });

  final AllChatStatus status;
  final List<Chat> allChat;
  final bool hasReachedMax;

  AllChatState copyWith({
    AllChatStatus? status,
    List<Chat>? allChat,
    bool? hasReachedMax,
  }) {
    return AllChatState(
      status: status ?? this.status,
      allChat: allChat ?? this.allChat,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''AllChatState { status: $status, hasReachedMax: $hasReachedMax, allChat: ${allChat.length} }''';
  }

  @override
  List<Object> get props => [status, allChat, hasReachedMax];
}