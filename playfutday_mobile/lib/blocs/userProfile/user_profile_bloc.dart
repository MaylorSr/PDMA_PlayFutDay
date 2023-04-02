import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:stream_transform/stream_transform.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc(this._userService) : super(const UserProfileState()) {
    on<UserProfileFetched>(
      _onProfileFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<EditProfileState>(_editProfileState);
    on<UpdateUser>(
      _updateUser,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final UserService _userService;

  // ignore: unused_element
  Future<void> _onProfileFetched(
      UserProfileFetched event, Emitter<UserProfileState> emitter) async {
    try {
      if (state.status == UserProfileStatus.initial) {
        final user = await _userService.getCurrentUserInfo(event.id);
        return emitter(state.copyWith(
          status: UserProfileStatus.success,
          user: user!,
        ));
      }
      final user = await _userService.getCurrentUserInfo(event.id);

      emitter(state.copyWith(
        status: UserProfileStatus.success,
        user: user,
      ));
    } catch (_) {
      emitter(state.copyWith(status: UserProfileStatus.failure));
    }
  }

  Future<void> _editProfileState(
      EditProfileState event, Emitter<UserProfileState> emit) async {
    return emit(state.copyWith(status: UserProfileStatus.editProfile));
  }

  Future<void> _updateUser(
      UpdateUser event, Emitter<UserProfileState> emit) async {
    /**
         * Variable para evitar realizar la petición cuando el usuario le de a cancelar
         */
    // bool changeUser = false;
    try {
      if (event.userNow.biography != event.updateUser.biography) {
        await _userService.editBio(event.updateUser.biography!);
        // changeUser = true;
      }

      if (event.userNow.birthday != event.updateUser.birthday) {
        await _userService.editBirthday(event.updateUser.birthday!);
        // changeUser = true;
      }

      if (event.userNow.phone != event.updateUser.phone) {
        await _userService.editPhone(event.updateUser.phone!);
        // changeUser = true;
      }
      if (event.updateUser.avatar != null) {
        if (event.updateUser.avatar!.path.split('/').last !=
            event.userNow.avatar!.toString()) {
          await _userService.editAvatar(event.updateUser.avatar!);
        }
      }
      // changeUser = true;

      final updateUser =
          await _userService.getCurrentUserInfo(event.userNow.id.toString());
      return emit(
          state.copyWith(status: UserProfileStatus.success, user: updateUser));
    } catch (_) {}
  }
}
