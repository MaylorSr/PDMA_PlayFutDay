import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileFetched extends UserProfileEvent {
  @override
  UserProfileFetched(this.id);
  final String id;
}
