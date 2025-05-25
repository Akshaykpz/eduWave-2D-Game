import 'dart:developer';

import 'package:aptyou/data/api_client.dart';
import 'package:aptyou/data/token_response.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<TokenResponse?> fetchProtectedData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');

  if (token == null) {
    return null;
  }

  try {
    final dio = Dio();
    final apiClient = ApiClient(dio);

    final response = await apiClient.userGetDetails("Bearer $token");
    return response;
  } catch (e) {
    log("API fetch error: $e");
    return null;
  }
}
