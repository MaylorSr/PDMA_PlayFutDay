
import 'package:equatable/equatable.dart';

import '../../models/editProfile.dart';
import '../../models/user.dart';

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileFetched extends EditProfileEvent {
  @override
  EditProfileFetched(this.user);
  final User user;
}

class EditDataFetched extends EditProfileEvent {
  @override
  EditDataFetched(this.userEdit, this.user);
  final EditDataUser userEdit;
  final User user;
}
