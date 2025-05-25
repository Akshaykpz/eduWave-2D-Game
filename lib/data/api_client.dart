import 'package:aptyou/data/token_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://13.60.220.96:8000/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST("auth/v5/firebase/signin")
  Future<TokenResponse> firebaseSignIn(
    @Header("Authorization") String authorization,
    @Header("x-device-id") String deviceId,
    @Header("x-fcm-token") String fcmToken,
  );

  @GET("content/v5/sample-assets")
  Future<TokenResponse> userGetDetails(
    @Header("Authorization") String authorization,
  );
}
