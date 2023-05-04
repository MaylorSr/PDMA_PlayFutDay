// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';

import '../../rest/rest.dart';
import '../../services/services.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService authenticationService)
      // ignore: unnecessary_null_comparison
      : assert(authenticationService != null),
        _authenticationService = authenticationService,
        super(AuthenticationInitial()) {
    on<AppLoaded>(_onAppLoaded);
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
    on<SessionExpiredEvent>(_onSessionExpired);
  }

  _onAppLoaded(
    AppLoaded event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoading());
    try {
      await Future.delayed(
          const Duration(milliseconds: 300)); // a simulated delay
      final currentUser = await _authenticationService.getCurrentUser();
      if (currentUser != null) {
        emit(AuthenticationAuthenticated(user: currentUser));
      } else {
        emit(AuthenticationNotAuthenticated());
      }
    } on UnauthorizedException {
      emit(AuthenticationNotAuthenticated());
    } on Exception catch (e) {
      emit(AuthenticationFailure(
          message: 'An unknown error occurred: ${e.toString()}'));
    }
  }

  _onUserLoggedIn(
    UserLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationAuthenticated(user: event.user));
  }

  _onUserLoggedOut(
    UserLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationService.signOut();
    emit(AuthenticationNotAuthenticated());
  }

  _onSessionExpired(
    SessionExpiredEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    //emit(AuthenticationFailure(message: 'An unknown error occurred: ${e.toString()}'));
    print("sesión expirada");
    await _authenticationService.signOut();
    emit(const SessionExpiredState());
  }
}
