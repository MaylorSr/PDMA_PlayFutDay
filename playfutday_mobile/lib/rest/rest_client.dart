// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_new, prefer_collection_literals, depend_on_referenced_packages, avoid_, duplicate_ignore

import 'dart:convert';
import 'dart:io';

// import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/models/refresh_token_model.dart';
import 'package:playfutday_flutter/services/localstorage_service.dart';
import 'package:http_parser/http_parser.dart';

import '../main.dart';

class ApiConstants {
  static String baseUrl = /*"http://localhost:8080" */ "http://10.0.2.2:8080";
}

class HeadersApiInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers["Content-Type"] = "application/json";
      data.headers["Accept"] = "application/json";
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  //Number of retry
  @override
  // ignore: overridden_fields
  int maxRetryAttempts = 2;
  // String token = LocalStorageService().getFromDisk("user_token");
  String refreshTokenNow =
      const LocalStorageService().getFromDisk("user_refresh_token");
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    final usuario = await refreshToken(refreshTokenNow);
    if (usuario != null) {
      saveStateTokens(
          usuario.token.toString(), usuario.refreshToken.toString());
      return false;
    }
    return true;
  }

  Future<User?> refreshToken(String refreshToken) async {
    const String urlRefresh = "/refresh/token";
    final body = RefreshTokenModel(refreshToken: refreshToken);

    final response =
        await http.post((ApiConstants.baseUrl + urlRefresh).toUri(),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body));

    if (response.statusCode != 201) {
      return null;
    } else {
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    }
  }

  void saveStateTokens(String token, String refreshToken) {
    const LocalStorageService().saveToDisk("user_refresh_token", refreshToken);
    const LocalStorageService().saveToDisk("user_token", token);
  }
}

@Order(-10)
@singleton
class RestClient {
  var _httpClient;

  RestClient() {
    _httpClient =
        InterceptedClient.build(interceptors: [HeadersApiInterceptor()]);
  }

  RestClient.withInterceptors(List<InterceptorContract> interceptors) {
    // El interceptor con los encabezados sobre JSON se añade si no está incluido en la lista
    if (interceptors
        // ignore: prefer_iterable_wheretype
        .where((element) => element is HeadersApiInterceptor)
        // ignore: avoid_single_cascade_in_expression_statements
        .isEmpty) interceptors..add(HeadersApiInterceptor());
    _httpClient = InterceptedClient.build(interceptors: interceptors);
  }

  Future<dynamic> get(String url) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.get(uri);
      var responseJson = _response(response);
      return responseJson;
    } on SocketException catch (ex) {
      throw FetchDataException(
          'You not have internet connection: ${ex.message}');
    }
  }

  Future<dynamic> post(String url, dynamic body) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.post(uri, body: jsonEncode(body));
      var responseJson = _response(response);
      return responseJson;
    } on Exception catch (ex) {
      // ignore: use_rethrow_when_possible
      throw ex;
    }
  }

  Future<http.Response> put(String url, dynamic body) async {
    Uri uri = Uri.parse(ApiConstants.baseUrl + url);

    final response = await _httpClient.put(uri, body: jsonEncode(body));
    return response;
  }

  Future<void> deleteP(String url) async {
    try {
      // ignore: unused_local_variable
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.delete(uri);
      var responseJson = _response(response);
      return responseJson;
    } on Exception catch (ex) {
      // ignore: use_rethrow_when_possible
      throw ex;
    }
  }

  Future<dynamic> verifyCode(String url, String code) async {
    Uri uri = Uri.parse(ApiConstants.baseUrl + url);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': 'NoAuth'},
    );
    return response;
  }

  // TODO REQUIRE DE REFRESH TOKEN EDIT AVATAR
  Future<dynamic> editAvatar(File file, String accessToken, String url) async {
    var bytes = await file.readAsBytes();

    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      Map<String, String> headers = Map();
      headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ${accessToken}',
      });
      var request = new http.MultipartRequest('POST', uri);
      final httpImage = http.MultipartFile.fromBytes('image', bytes,
          contentType: MediaType('image', file.path.split('.').last),
          filename: file.path.split('/').last);
      request.files.add(httpImage);
      request.headers.addAll(headers);

      final response = await _httpClient!.send(request);
      var responseJson = response.stream.bytesToString();
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
  }

  // TODO REQUIRE DE REFRESH TOKEN NEW POST
  Future<dynamic> newPost(
      String url, dynamic body, File file, String accessToken) async {
    var bytes = await file.readAsBytes();

    Uri uri = Uri.parse(ApiConstants.baseUrl + url);

    Map<String, String> headers = Map();
    headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${accessToken}',
    });
    var bodyPart;
    var request = new http.MultipartRequest('POST', uri);
    final httpImage = http.MultipartFile.fromBytes('image', bytes,
        contentType: MediaType('image', file.path.split('.').last),
        filename: file.path.split('/').last);
    request.files.add(httpImage);
    request.headers.addAll(headers);
    if (body != null) {
      bodyPart = http.MultipartFile.fromString('post', jsonEncode(body),
          contentType: MediaType('application', 'json'));
      request.files.add(bodyPart);
    }

    final response = await _httpClient!.send(request);
    return response;
    // final response = await _httpClient!.send(request);
    // return response;
  }

  Future<http.Response> singUpPost(String url, dynamic body) async {
    Uri uri = Uri.parse(ApiConstants.baseUrl + url);
    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'NoAuth'
        },
        body: jsonEncode(body));
    return response;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 204:
        return;
      case 400:
        return;
      case 401:
        // Así sacamos el mensaje del JSON devuelto por el API
        //String message = jsonDecode(utf8.decode(response.bodyBytes))['message'];
        //throw AuthenticationException(message);

        // Así devolvemos un mensaje "genérico"
        throw AuthenticationException(
            "You have entered an invalid username or password");
      case 403:
        throw UnauthorizedException(utf8.decode(response.bodyBytes));
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes));
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: annotate_overrides

class CustomException implements Exception {
  final message;
  final _prefix;

  CustomException([this.message, this._prefix]);

  String toString() {
    return "$_prefix$message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class AuthenticationException extends CustomException {
  AuthenticationException([message]) : super(message, "");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "");
}

class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "");
}

class AuthorizationInterceptor implements InterceptorContract {
  late LocalStorageService _localStorageService;

  AuthorizationInterceptor() {
    //_localStorageService = getIt<LocalStorageService>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      var token = await _localStorageService.getFromDisk("user_token");
      // ignore: prefer_interpolation_to_compose_strings
      data.headers["Authorization"] = "Bearer " + token;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    return Future.value(data);
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401 || data.statusCode == 403) {
      bool responseData =
          await ExpiredTokenRetryPolicy().shouldAttemptRetryOnResponse(data);
      if (!responseData) {
        var request = data.request;
        request!.headers["Authorization"] =
            // ignore: prefer_interpolation_to_compose_strings
            "Bearer " + _localStorageService.getFromDisk("user_token");
        var retryResponseStream = await request.toHttpRequest().send();
        var retryResponse = await http.Response.fromStream(retryResponseStream);
        var datos = ResponseData.fromHttpResponse(retryResponse);
        return Future.value(datos);
      } else {
        Navigator.of(GlobalContext.ctx).push<void>(MyApp.route());
      }
    }
    return Future.value(data);
  }
}

@Order(-10)
@singleton
class RestAuthenticatedClient extends RestClient {
  RestAuthenticatedClient()
      : super.withInterceptors(
            List.of(<InterceptorContract>[AuthorizationInterceptor()]));
}
