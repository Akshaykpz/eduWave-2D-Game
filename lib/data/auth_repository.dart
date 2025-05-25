import 'package:aptyou/data/auth_proivder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'api_client.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  Future<bool> signInAndCallApi() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return false;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseIdToken = await userCredential.user?.getIdToken();
    if (firebaseIdToken == null) {
      return false;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final deviceId = androidInfo.id ?? 'unknown-device';
    final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

    return await callFirebaseSigninApi(
      firebaseIdToken: firebaseIdToken,
      deviceId: deviceId,
      fcmToken: fcmToken,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
