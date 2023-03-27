import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile.dart';
import 'package:playfutday_flutter/blocs/userProfile/user_profile_bloc.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'edit_profile.evet.dart';
import 'edit_profile_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc(this._userService) : super(const EditProfileState()) {
    on<EditProfileFetched>(
      _onEditProfileFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<EditDataFetched>(_editDataUser);
  }

  final UserService _userService;

  Future<void> _onEditProfileFetched(
      EditProfileFetched event, Emitter<EditProfileState> emitter) async {
    try {
      if (state.status == EditProfileStatus.initial) {
        final user = event.user;
        return emitter(state.copyWith(
          status: EditProfileStatus.success,
          user: user,
        ));
      }
      final user = event.user;

      emitter(state.copyWith(
        status: EditProfileStatus.success,
        user: user,
      ));
    } catch (_) {
      emitter(state.copyWith(status: EditProfileStatus.failure));
    }
  }

  Future<void> _editDataUser(
      EditDataFetched event, Emitter<EditProfileState> emit) async {
    try {
      if (event.userEdit.biography != event.user.biography) {
        await _userService.editBio(event.userEdit.biography!);
      }

      if (event.userEdit.birthday != event.user.birthday) {
        await _userService.editBirthday(event.userEdit.birthday!);
      }

      if (event.userEdit.phone != event.user.phone) {
        await _userService.editPhone(event.userEdit.phone!);
      }

      final user = state.user!.copyWith(
        biography: event.userEdit.biography ?? state.user!.biography,
        birthday: event.userEdit.birthday ?? state.user!.birthday,
        phone: event.userEdit.phone ?? state.user!.phone,
      );
    
    
    } catch (_) {
      emit(state.copyWith(status: EditProfileStatus.failure));
    }
  }
}
