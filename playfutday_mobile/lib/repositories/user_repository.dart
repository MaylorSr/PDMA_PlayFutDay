import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:playfutday_flutter/models/change_password_request.dart';
import 'package:playfutday_flutter/models/editProfile.dart';
import 'package:playfutday_flutter/models/sing_up.dart';

import '../config/locator.dart';
import '../models/infoUser.dart';
import '../models/models.dart';
import '../rest/rest_client.dart';

class UserRepository {
  late RestAuthenticatedClient _client;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> me() async {
    String url = "/me";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> singUp(RegisterRequest body) async {
    String url = "/auth/register";
    var jsonResponse = await _client.singUpPost(url, body);
    return jsonResponse;
  }

  Future<dynamic> getStateThatFollowUserByMe(String id) async {
    String url = "/state/follow/user/$id";
    var jsonResponse = await _client.get(url);
    return jsonResponse;
  }

  Future<dynamic> verifyCode(String code) async {
    String url = "/auth/verifyCode/$code";
    var jsonResponse = await _client.verifyCode(url, code);
    return jsonResponse;
  }

  Future<dynamic> getProfile(String id) async {
    String url = "/info/user/$id";

    var jsonResponse = await _client.get(url);
    return UserInfo.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> editAvatar(String token, File file) async {
    String url = "/edit/avatar";
    var jsonResponse = await _client.editAvatar(file, token, url);
    return jsonResponse;
  }

  Future<dynamic> editBioByMe(String biography) async {
    String url = "/edit/bio";
    EditDataUser request = EditDataUser(biography: biography);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<dynamic> editPhoneByMe(String phone) async {
    String url = "/edit/phone";
    EditDataUser request = EditDataUser(phone: phone);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<dynamic> editBirthdayByMe(String birthday) async {
    String url = "/edit/birthday";
    EditDataUser request = EditDataUser(birthday: birthday);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<void> deleteUser(String userId) async {
    String url = "/user/$userId";
    // ignore: avoid_print
    print(userId);
    // ignore: unused_local_variable
    var jsonResponse = await _client.deleteP(url);
  }

  Future<dynamic> banUser(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/banUserByAdmin/${uuid}";
    await _client.post(url, null);
  }

  Future<dynamic> changeRole(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/changeRole/${uuid}";

    await _client.post(url, null);
  }

  Future<dynamic> addFollow(String uuid) async {
    String url = "/user/follow/$uuid";

    await _client.post(url, null);
  }

  Future<dynamic> getFollowers([int index = 0, uuid]) async {
    String url = "/user/followers/$uuid?page=$index";

    final jsonResponse = await _client.get(url);

    return UserFollowResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> getFollows([int index = 0, uuid]) async {
    String url = "/user/follows/$uuid?page=$index";

    final jsonResponse = await _client.get(url);

    return UserFollowResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    String url = "/user/changePassword";
    ChangePasswordRequest request = ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        verifyNewPassword: confirmPassword);
    var response = await _client.put(url, request.toJson());
    return response;
  }
}
