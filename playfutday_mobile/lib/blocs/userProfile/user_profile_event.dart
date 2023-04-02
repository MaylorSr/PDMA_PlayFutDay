import 'package:equatable/equatable.dart';

import '../../models/editProfile.dart';
import '../../models/infoUser.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileFetched extends UserProfileEvent {
  @override
  UserProfileFetched(this.id);
  final String id;
}

class EditProfileState extends UserProfileEvent {}

class UpdateUser extends UserProfileEvent {
  @override
  UpdateUser(this.updateUser, this.userNow);

  final EditDataUser updateUser;
  final UserInfo userNow;
  
}
