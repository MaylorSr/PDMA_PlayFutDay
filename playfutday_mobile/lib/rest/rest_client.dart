// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_new, prefer_collection_literals, depend_on_referenced_packages, avoid_print, duplicate_ignore

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:playfutday_flutter/main.dart';
import 'package:playfutday_flutter/services/localstorage_service.dart';
import 'package:http_parser/http_parser.dart';

class ApiConstants {
  static String baseUrl = /*"http://localhost:8080"*/ "http://10.0.2.2:8080";
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

  Future<dynamic> put(String url, dynamic body) async {
    try {
      Uri uri = Uri.parse(ApiConstants.baseUrl + url);

      final response = await _httpClient.put(uri, body: jsonEncode(body));
      var responseJson = _response(response);
      return responseJson;
    } on Exception catch (ex) {
      // ignore: use_rethrow_when_possible
      throw ex;
    }
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

  Future<dynamic> newPost(
      String url, dynamic body, File file, String accessToken) async {
    var bytes = await file.readAsBytes();

    try {
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
      print(response);
      var responseJson = response.stream.bytesToString();
      print(responseJson);
      return responseJson;
    } on SocketException catch (ex) {
      throw Exception('No internet connection: ${ex.message}');
    }
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
    print(response.body); /*
    ApiError error = jsonDecode(response.body);*/

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
      // ignore: prefer_const_constructors
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(GlobalContext.ctx).push<void>(MyApp.route());
      });
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
