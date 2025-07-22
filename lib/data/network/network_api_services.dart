import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../helper/extension/string_extension.dart';
import '../../data/network/base_api_services.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../app_exceptions.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future<Map?> getApi(String url, requestName, {headers}) async {
    if (kDebugMode) {
      debugPrint(url);
    }

    Map? responseJson;
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        // debugPrint(response.body.toString());
        debugPrint(response.statusCode.toString());
      }
      responseJson = returnResponse(response);
    } on SocketException {
      InternetException('');
      debugPrint("invalid url");
      showError(requestName, "Invalid url".tr());
    } on RequestTimeOut {
      debugPrint("request timeout");
      showError(requestName, "Request timeout".tr());
      RequestTimeOut('');
    } catch (e) {
      debugPrint(e.toString());
      showError(requestName, e.toString());
    }
    // debugPrint(responseJson?.toString());
    return responseJson;
  }

  @override
  Future<Map?> postApi(var data, String url, requestName, {headers}) async {
    if (kDebugMode) {
      debugPrint(url);
      debugPrint(data.toString());
    }

    Map? responseJson;
    try {
      final response = await http
          .post(Uri.parse(url), body: data, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        // debugPrint(response.body.toString());
        debugPrint(response.statusCode.toString());
      }
      responseJson = returnResponse(response);
    } on SocketException {
      debugPrint("invalid url");
      showError(requestName, "Invalid url".tr());
    } on RequestTimeOut {
      debugPrint("request timeout");
      showError(requestName, "Request timeout".tr());
    } catch (e) {
      showError(requestName, e.toString());
      debugPrint(e.toString());
    }
    return responseJson;
  }

  Future<Map?> postWithFileApi(http.MultipartRequest request, requestName,
      {headers}) async {
    if (kDebugMode) {
      debugPrint(request.url.toString());
      debugPrint(request.fields.toString());
    }

    Map? responseJson;
    try {
      final responseStream = await request.send();
      final data = await responseStream.stream.toBytes();
      http.Response response =
          http.Response.bytes(data, responseStream.statusCode);
      if (kDebugMode) {
        // debugPrint(response.body.toString());
        debugPrint(responseStream.statusCode.toString());
      }
      responseJson = returnResponse(response);
    } on SocketException {
      debugPrint("invalid url");
      showError(requestName, "Invalid url".tr());
    } on RequestTimeOut {
      debugPrint("request timeout");
      showError(requestName, "Request timeout".tr());
    } catch (e) {
      showError(requestName, e.toString());
      debugPrint(e.toString());
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          dynamic responseJson = jsonDecode(response.body);
          // if (responseJson["message"] != null) {
          //   responseJson["message"].toString().showToast();
          //   return null;
          // }
          return responseJson;
        } catch (_) {
          return {};
        }
      case 201:
        try {
          dynamic responseJson = jsonDecode(response.body);
          // if (responseJson["message"] != null) {
          //   responseJson["message"].toString().showToast();
          //   return null;
          // }
          return responseJson;
        } catch (_) {
          return {};
        }

      case 400:
        try {
          dynamic responseJson = jsonDecode(response.body);
          if (responseJson["message"] != null) {
            responseJson["message"].toString().showToast();
            return null;
          }
        } catch (_) {
          debugPrint(response.body.toString());
          throw FetchDataException('${response.reasonPhrase}');
        }
        return;
      case 422:
        try {
          dynamic responseJson = jsonDecode(response.body);
          if (responseJson["message"] != null) {
            responseJson["message"].toString().showToast();
            return null;
          }
        } catch (_) {
          debugPrint(response.body.toString());
          throw FetchDataException('${response.reasonPhrase}');
        }
        return;

      default:
        try {
          dynamic responseJson = jsonDecode(response.body);
          if (responseJson["message"] != null) {
            responseJson["message"].toString().showToast();
            return null;
          }
        } catch (_) {
          // if (response.body.contains("Unauthenticated.")) {
          //   debugPrint(navigatorKey.currentState?.toString());
          //   navigatorKey.currentState?.pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (context) => const SignInView(),
          //       ),
          //       (route) => false);
          //   return LocalKeys.sessionExpired.showToast();
          // }
          debugPrint(response.body.toString());
          throw FetchDataException('${response.reasonPhrase}');
        }
    }
  }

  showError(requestName, error) {
    if (requestName != null) {
      "$requestName: $error".showToast();
    }
  }
}
