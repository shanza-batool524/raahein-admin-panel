import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:developer';

import '../../sessionManger/session_controller.dart';
import '../app_exceptions.dart';
import 'base_api_service.dart';
import 'package:http/http.dart' as http;

class NetworkApiService extends BaseApiServices {

  /// Helper method to ensure the token is loaded and returned safely
  Future<String?> _getToken() async {
    final session = SessionController();
    if (!session.isLogin && session.userDataModel.token == null) {
      await session.getUserPreference();
    }
    return session.userDataModel.token;
  }

  /// Helper to handle unauthorized access
  void _handleUnauthorized() {
    log("🚫 Token missing or expired — redirecting to login");
    final session = SessionController();
    session.isLogin = false;

    if (!session.isRedirectingToLogin) {
      session.isRedirectingToLogin = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAllNamed('/login'); // Using explicit string /login for now based on routenames.
        session.isRedirectingToLogin = false;
      });
    }
  }

  @override
  Future<dynamic> getApi({
    required String url,
    required bool isHeaderRequired,
  }) async {
    try {
      dynamic responseJson;
      Map<String, String> headerMap = {"Accept": "application/json"};

      if (isHeaderRequired) {
        String? token = await _getToken();
        log("🪙 Token before API call: $token");

        if (token == null || token.isEmpty) {
          _handleUnauthorized();
          return {"success": false, "message": "Unauthenticated"};
        }
        headerMap["Authorization"] = "Bearer $token";
        headerMap["Content-Type"] = "application/json";
      }

      final response = await http
          .get(Uri.parse(url), headers: headerMap)
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw InternetException('No Internet connection');
    } on TimeoutException {
      throw RequestTimeOut('Request timed out');
    }
  }


  @override
  Future postApi({
    var data,
    required String url,
    bool isHeadSet = true, // Default true kiya hai taaki JSON jaye
    required bool isHeaderRequired,
  }) async {
    dynamic responseJson;

    try {
      Map<String, String> headerMap = {
        "Accept": "application/json",
        "Content-Type": "application/json", // Hamesha JSON bhejna safe hai
      };

      if (isHeaderRequired) {
        String? token = await _getToken();
        if (token == null || token.isEmpty) {
          _handleUnauthorized();
          return null;
        }
        headerMap["Authorization"] = 'Bearer $token';
      }

      // FIX: Data ko hamesha encode karna chahiye agar wo Map hai
      var body = data is Map || data is List ? jsonEncode(data) : data;

      final response = await http
          .post(Uri.parse(url), body: body, headers: headerMap)
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
      log("responseJson: $responseJson ");
      return responseJson;
    } on SocketException {
      throw InternetException('No internet');
    } on TimeoutException {
      throw RequestTimeOut('Timeout');
    }
  }

  @override
  Future putApi({
    required data,
    required String url,
    required bool isHeaderRequired,
  }) async {
    dynamic responseJson;
    try {
      Map<String, String> headerMap = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      if (isHeaderRequired) {
        String? token = await _getToken();
        if (token == null || token.isEmpty) {
          _handleUnauthorized();
          return null;
        }
        headerMap["Authorization"] = 'Bearer $token';
      }

      final response = await http
          .put(Uri.parse(url), body: jsonEncode(data), headers: headerMap)
          .timeout(const Duration(seconds: 10));

      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    }
  }

  @override
  Future<dynamic> deleteApi({
    required String url,
    required bool isHeaderRequired,
  }) async {
    try {
      Map<String, String> headerMap = {"Accept": "application/json"};

      if (isHeaderRequired) {
        String? token = await _getToken();
        if (token == null || token.isEmpty) {
          _handleUnauthorized();
          return null;
        }
        headerMap["Authorization"] = 'Bearer $token';
      }

      final response = await http
          .delete(Uri.parse(url), headers: headerMap)
          .timeout(const Duration(seconds: 10));

      return returnResponse(response);
    } on SocketException {
      throw InternetException('');
    } on TimeoutException {
      throw RequestTimeOut('');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 404:
      case 422:
        return jsonDecode(response.body);
      case 401:
        _handleUnauthorized();
        return {"success": false, "message": "Unauthenticated"};
      case 500:
      default:
        log("🔥 Server Error: ${response.statusCode} - ${response.body}");
        return {"success": false, "message": "Server Error"};
    }
  }

  @override
  Future<dynamic> postStrpieApi({
    required data,
    required String url,
    required String token,
  }) async {
    try {
      final headerMap = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": 'Bearer $token',
      };
      final response = await http
          .post(Uri.parse(url), body: data, headers: headerMap)
          .timeout(const Duration(seconds: 10));
      return response;
    } on SocketException {
      throw InternetException('');
    }
  }
}