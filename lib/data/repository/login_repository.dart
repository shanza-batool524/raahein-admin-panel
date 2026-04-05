import 'dart:developer';
import '../models/login_response_model/login_response_model.dart';
import '../network/network_api_service.dart';

class LoginRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<LoginResponseModel> loginApi(var data) async {
    try {
      log("📤 Sending exact Login Payload to Backend: $data");
      
      dynamic response = await _apiService.postApi(
        url: 'https://raaheinbackend-production.up.railway.app/api/v1/auth/login',
        data: data,
        isHeaderRequired: false,
      );
      
      log("📥 Received Exact Login Response: $response");
      
      // Map response to the model
      return LoginResponseModel.fromJson(response);
    } catch (e) {
      log("💥 Login API Crash: $e");
      rethrow;
    }
  }
}
