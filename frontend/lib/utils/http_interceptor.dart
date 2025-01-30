import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class HttpInterceptor {
  static final HttpInterceptor _instance = HttpInterceptor._internal();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  factory HttpInterceptor() {
    return _instance;
  }

  HttpInterceptor._internal();

  /// ✅ HTTP 요청 시 자동으로 `ACCESS_TOKEN`을 가져와 헤더에 추가하는 메서드
  Future<http.Response> get(Uri url) async {
    final String? accessToken = await secureStorage.read(key: "jwt_token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("🚨 토큰이 없습니다. 다시 로그인해주세요.");
    }

    print("🔑 요청에 사용될 ACCESS_TOKEN: $accessToken");

    return http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'ACCESS_TOKEN=$accessToken',
      },
    );
  }

  Future<http.Response> post(Uri url, {Map<String, dynamic>? body}) async {
    final String? accessToken = await secureStorage.read(key: "jwt_token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("🚨 토큰이 없습니다. 다시 로그인해주세요.");
    }

    print("🔑 요청에 사용될 ACCESS_TOKEN: $accessToken");

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'ACCESS_TOKEN=$accessToken',
      },
      body: body != null ? jsonEncode(body) : null, // 🚀 JSON 변환 추가,
    );
  }

  Future<http.Response> put(Uri url, {Object? body}) async {
    final String? accessToken = await secureStorage.read(key: "jwt_token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("🚨 토큰이 없습니다. 다시 로그인해주세요.");
    }

    print("🔑 요청에 사용될 ACCESS_TOKEN: $accessToken");

    return http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'ACCESS_TOKEN=$accessToken',
      },
      body: body,
    );
  }

  Future<http.Response> delete(Uri url) async {
    final String? accessToken = await secureStorage.read(key: "jwt_token");

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception("🚨 토큰이 없습니다. 다시 로그인해주세요.");
    }

    print("🔑 요청에 사용될 ACCESS_TOKEN: $accessToken");

    return http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Cookie': 'ACCESS_TOKEN=$accessToken',
      },
    );
  }
}