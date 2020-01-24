import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tracers/trace.dart' as Log;
import 'package:http/http.dart' as http;

/// See [Article] at https://medium.com/flutter-community/handling-network-calls-like-a-pro-in-flutter-31bd30c86be1
/// Great article to handle network calls by created helper class, custom exceptions, and generic API responses.
///

abstract class ApiBase {
  String get baseUrl;
  Future<dynamic> getJson({@required String url, String token});
  Future<dynamic> postJson({@required String url, String token, Map<String, String> body});
}

enum NetworkState { LOADING, COMPLETED, ERROR }

/// Network calls are wrapped in try/catch blocks, an non-error response is wrapped in ApiResponse.completed(data),
/// any errors are wrapped in ApiResponse.error, this allows for network status(besides 200) to be clearly reported
/// and handled.
class ApiResponse<T> {
  NetworkState status;
  T data;
  String message;
  ApiException exception;

  ApiResponse.loading(this.message) : status = NetworkState.LOADING;
  ApiResponse.completed(this.data) : status = NetworkState.COMPLETED;
  ApiResponse.error(this.exception) : status = NetworkState.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

class ApiException implements Exception {
  final message;
  final prefix;
  final code;
  ApiException([this.message, this.prefix, this.code]);

  String toString() {
    return '{"$prefix" : $message"}';
  }
}

/// ApiException for http response code errors
// HTTP 400
class BadRequestException extends ApiException {
  BadRequestException([message, int code]) : super(message, "Invalid Request", code);
}

// HTTP 404
class CantFindRequestedPage extends ApiException {
  CantFindRequestedPage([String message, int code]) : super(message, "Cannot find page", code);
}

// Error outside of HTTP codes (network connection down?)
class FetchDataException extends ApiException {
  FetchDataException([String message, int code]) : super(message, "Error During Communication", code);
}

// HTTP 401 & 403
class UnauthorizedException extends ApiException {
  UnauthorizedException([message, int code]) : super(message, "Unauthorized", code);
}

// TODO: Future feature.
class InvalidInputException extends ApiException {
  InvalidInputException([String message, int code]) : super(message, "Invalid Input", code);
}

/// Network calls are made through instance of this class, all responses are wrapped in ApiResponse<T> class,
/// so all network errors are handled at this layer and reported to the caller, this allows for better
/// error handling and improved separation-of-concerns.
/// Common HTTP errors (400, 401,...) are wrapped in custom exceptions so that the ui layer can better report
/// issues without having to deconstruct error codes.
class NetworkApi implements ApiBase {
  final String baseUrl;
  NetworkApi({@required this.baseUrl});

  Future<dynamic> getJson({@required String url, String token}) async {
    assert(url != null);
    final headers = (token == null) ? null : {"Authorization": "$token", "Content-Type": "application/json"};
    var responseJson;
    try {
      /// If the 'GET' completes without a hardware error, the response is
      /// bundled with any status information (200, 404, etc)
      final response = await http.get(baseUrl + url, headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postJson({@required String url, String token, Map<String, String> body}) async {
    Log.t('postJson url => $url');
    final header = (token == null) ? null : {"Authorization": "$token", "Content-Type": "application/json"};
    var responseJson;
    try {
      final fullUrl = baseUrl + url;
      if (header != null && body != null) {
        final encoded = json.encode(body);
        final response = await http.post(fullUrl, headers: header, body: encoded);
        responseJson = _returnResponse(response);
      } else {
        final response = await http.post(fullUrl, headers: header, body: body);
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection', 0);
    }
    return responseJson;
  }

  /// Takes the http response and checks for 200 and wraps the result into the responses,
  /// any other errors are found and custom exceptions are thrown, this will wrap the response
  /// with information for the caller to respond to.
  dynamic _returnResponse(http.Response response) {
    Log.t('network_apis.dart HTTP response status code ${response?.statusCode}');
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());

        /// No error, the responses data was decoded and returned to the caller where its wrapped in 'Success' response.
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString(), response.statusCode);
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString(), response.statusCode);
      case 404:
        throw CantFindRequestedPage(response.body.toString(), response.statusCode);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}', response.statusCode);
    }
  }
}

class NetworkMock implements ApiBase {
  final String baseUrl;
  NetworkMock({@required this.baseUrl});

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString(), response.statusCode);
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString(), response.statusCode);
      case 404:
        throw CantFindRequestedPage(response.body.toString(), response.statusCode);
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}', response.statusCode);
    }
  }

  @override
  Future getJson({String url, String token}) {
    Log.toDo('network_apis.dart - create getJson');
    return null;
  }

  @override
  Future postJson({String url, String token, Map<String, String> body}) {
    Log.toDo('network_apis.dart - create postJson');
    _returnResponse(null); //TODO:
    return null;
  }
}
