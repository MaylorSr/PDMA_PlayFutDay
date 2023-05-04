import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/models/models.dart';

import '../config/locator.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/user_repository.dart';
import 'localstorage_service.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User> signInWithUserNameAndPassword(String username, String password);
  Future<void> signOut();
}

@Order(2)
@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  LocalStorageService _localStorageService = const LocalStorageService();
  late UserRepository _userRepository;

  JwtAuthenticationService() {
    _authenticationRepository = getIt<AuthenticationRepository>();
    _userRepository = getIt<UserRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    //String? loggedUser = _localStorageService.getFromDisk("user");
    ("get current user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserResponse response = await _userRepository.me();
      (response);
      return response;
    }
    return null;
  }

  @override
  Future<User> signInWithUserNameAndPassword(
      String username, String password) async {
    User response = await _authenticationRepository.doLogin(username, password);
    await _localStorageService.saveToDisk('user_token', response.token);
    await _localStorageService.saveToDisk(
        'user_refresh_token', response.refreshToken);
    return response;
  }

  @override
  Future<void> signOut() async {
    ("borrando token y refresh token");
    await _localStorageService.deleteFromDisk("user_token");
    await _localStorageService.deleteFromDisk("user_refresh_token");
  }
}
