import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> callFirebaseSigninApi({
  required String firebaseIdToken,
  required String deviceId,
  required String fcmToken,
}) async {
  log("this token auth$firebaseIdToken");
  log("this is id---------$deviceId");
  log("thi is  fcm   $fcmToken");
  final dio = Dio();

  try {
    final response = await dio.post(
      'http://13.60.220.96:8000/auth/v5/firebase/signin',
      options: Options(
        headers: {
          'Authorization': 'Bearer $firebaseIdToken',
          'x-device-id': deviceId,
          'x-fcm-token': fcmToken,
          'x-secret-key': 'uG7pK2aLxX9zR1MvWq3EoJfHdTYcBn84',
        },
      ),
      data: {},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final accessToken = response.data['data']['accessToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      log('API Success: $accessToken');
      return true;
    } else {
      log('API Failed with status: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('API Error: $e');
    return false;
  }
}

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  return token != null && token.isNotEmpty;
}
