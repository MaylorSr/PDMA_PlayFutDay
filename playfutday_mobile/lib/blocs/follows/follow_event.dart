// ignore: file_names
import 'package:equatable/equatable.dart';

abstract class AllFollowEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllFollowFetched extends AllFollowEvent {}

class AddFollowFetched extends AllFollowEvent {
  @override
  AddFollowFetched(this.id);

  final String id;
}
