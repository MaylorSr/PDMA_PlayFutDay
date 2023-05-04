// ignore_for_file: unnecessary_null_comparison, duplicate_ignore

import 'package:bloc/bloc.dart';
import '../../rest/rest_client.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication.dart';
import '../../services/services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc,
      AuthenticationService authenticationService)
      // ignore: unnecessary_null_comparison
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService,
        super(LoginInitial()) {
    on<LoginInWithUserNameButtonPressed>(
        __onLoggingInWithUserNameButtonPressed);
  }

  __onLoggingInWithUserNameButtonPressed(
    LoginInWithUserNameButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authenticationService.signInWithUserNameAndPassword(
          event.username, event.password);
      if (user != null) {
        _authenticationBloc.add(UserLoggedIn(user: user));
        emit(LoginSuccess());
        emit(LoginInitial());
      } else {
        emit(LoginFailure(error: 'Something very weird just happened'));
      }
    } on AuthenticationException catch (e) {
      emit(LoginFailure(error: e.message));
    } on CustomException catch (err) {
      emit(LoginFailure(error: 'An unknown error occurred ${err.message}'));
    }
  }
}
