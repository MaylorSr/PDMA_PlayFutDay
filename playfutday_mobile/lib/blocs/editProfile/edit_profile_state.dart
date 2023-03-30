import 'package:equatable/equatable.dart';
import '../../models/user.dart';

enum EditProfileStatus { initial, success, failure }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.user,
  });

  final EditProfileStatus status;
  final User? user;

  EditProfileState copyWith({
    EditProfileStatus? status,
    final User? user,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return '''EditProfileState { status: $status, user: $user }''';
  }

  @override
  List<Object> get props => [status];
}
