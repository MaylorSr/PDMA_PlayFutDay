import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:playfutday_flutter/models/editProfile.dart';

import '../config/locator.dart';
import '../models/infoUser.dart';
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

  Future<dynamic> getProfile(String id) async {
    String url = "/info/user/$id";

    var jsonResponse = await _client.get(url);
    return UserInfo.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> editAvatar(String token, File file ) async{
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
}
