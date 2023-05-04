import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/rest/rest.dart';
import '../models/models.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/auth/login";
    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return User.fromJson(jsonDecode(jsonResponse));
  }
}
