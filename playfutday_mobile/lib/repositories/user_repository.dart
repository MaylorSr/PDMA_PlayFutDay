import 'dart:async';
import 'dart:convert';

import '../config/locator.dart';
import '../models/user.dart';
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

  /*

  Future<dynamic> fecthUsersInfo(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/info/user/${uuid}";

    var jsonResponse = await _client.get(url);

    return InfoUser.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> editBioByMe(String biography) async {
    String url = "/edit/bio";
    EditProfileResponse request = EditProfileResponse(biography: biography);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<http.Response> editPhoneByMe(String phone) async {
    String url = "/edit/phone";
    EditProfileResponse request = EditProfileResponse(phone: phone);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<dynamic> editBirthdayByMe(String birthday) async {
    String url = "/edit/birthday";
    EditProfileResponse request = EditProfileResponse(birthday: birthday);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<UserResponseAdmin> getAllUsersByAdmin([int index = 0]) async {
    String url = "/user?page=$index";

    var jsonResponse = await _client.get(url);

    return UserResponseAdmin.fromJson(jsonDecode(jsonResponse));
  }
  */
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
}
