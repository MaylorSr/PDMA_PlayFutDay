import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'user_profile_event.dart';
import 'user_profile_state.dart';

const throttleDuration = Duration(milliseconds: 100);

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
  }

  // ignore: unused_field
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
}
