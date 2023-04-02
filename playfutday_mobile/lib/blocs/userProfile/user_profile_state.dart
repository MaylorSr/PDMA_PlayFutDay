import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/infoUser.dart';

enum UserProfileStatus { initial, success, failure, editProfile }

class UserProfileState extends Equatable {
  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.user,
  });

  final UserProfileStatus status;
  final UserInfo? user;

  UserProfileState copyWith({
    UserProfileStatus? status,
    final UserInfo? user,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return '''UserProfileState { status: $status, user: $user }''';
  }

  @override
  List<Object> get props => [status];
}
