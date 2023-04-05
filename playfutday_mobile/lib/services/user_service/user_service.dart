import 'dart:io';

import 'package:playfutday_flutter/models/infoUser.dart';
import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/repositories.dart';
import '../localstorage_service.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Order(2)
@singleton
class UserService {
  // ignore: unused_field
  late LocalStorageService _localStorageService = const LocalStorageService();
  late UserRepository _userRepository;
  // ignore: unused_field

  UserService() {
    _userRepository = GetIt.I.get<UserRepository>();

    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<UserInfo?> getCurrentUserInfo(String id) async {
    //String? loggedUser = _localStorageService.getFromDisk("user");
    print("get current user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserInfo response = await _userRepository.getProfile(id);
      print(response);
      return response;
    }
    return null;
  }

  Future<void> deleteUserOrMe(String userId) async {
    String? token = _localStorageService.getFromDisk('user_token');
    if (token != null) {
      _userRepository.deleteUser(userId);
    }
    // ignore: avoid_returning_null_for_void
    return null;
  }

  Future<dynamic> editBirthday(String birthday) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editBirthdayByMe(birthday);
      // ignore: avoid_print
    }
  }

  Future<dynamic> editAvatar(File file) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editAvatar(token, file);
      // ignore: avoid_print
    }
  }

  Future<dynamic> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.changePassword(
          oldPassword, newPassword, confirmPassword);
    }
  }

  Future<dynamic> editBio(String biography) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editBioByMe(biography);
      // ignore: avoid_print
    }
  }

  Future<dynamic> editPhone(String phone) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editPhoneByMe(phone);
    }
  }

  Future<dynamic> addFollow(String uuid) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.addFollow(uuid);
    }
  }

  Future<UserFollowResponse?> getFollowers([int index = 0, uuid]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserFollowResponse response =
          await _userRepository.getFollowers(index, uuid);
      return response;
    }
    return null;
  }

  Future<UserFollowResponse?> getFollows([int index = 0, uuid]) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserFollowResponse response =
          await _userRepository.getFollows(index, uuid);
      return response;
    }
    return null;
  }
}
