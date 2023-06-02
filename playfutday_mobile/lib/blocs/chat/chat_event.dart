import 'package:equatable/equatable.dart';

abstract class AllChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllChatFetched extends AllChatEvent {}


class OnRefreshChat extends AllChatEvent {}