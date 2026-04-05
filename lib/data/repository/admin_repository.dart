import 'dart:developer';
import '../../res/app_url/app_url.dart';
import '../models/user_model.dart';
import '../models/driver_model.dart';
import '../models/ride_model.dart';
import '../models/complaint_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/system_settings_model.dart';
import '../network/network_api_service.dart';

class AdminRepository {
  final NetworkApiService _apiService = NetworkApiService();

  // ─────────────────────────────────────────────────────────────────────────
  // USER MANAGEMENT
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getUsersApi,
        isHeaderRequired: true,
      );
      
      if (response != null && response is List) {
        return response.map((e) => UserModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("💥 getUsers Error: $e");
      rethrow;
    }
  }

  Future<UserModel> getUserProfile(int id) async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getUserProfileApi(id),
        isHeaderRequired: true,
      );
      return UserModel.fromJson(response);
    } catch (e) {
      log("💥 getUserProfile Error: $e");
      rethrow;
    }
  }

  Future<dynamic> updateUserStatus(int id, String status) async {
    try {
      final response = await _apiService.putApi(
        url: AppUrl.updateUserStatusApi(id),
        data: {"status": status},
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 updateUserStatus Error: $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DRIVER VERIFICATIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<DriverModel>> getPendingDriverVerifications() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getPendingDriverVerificationsApi,
        isHeaderRequired: true,
      );

      if (response != null && response is List) {
        return response.map((e) => DriverModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("💥 getPendingDriverVerifications Error: $e");
      rethrow;
    }
  }

  Future<DriverModel> getDriverVerificationDetails(int id) async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getDriverVerificationDetailsApi(id),
        isHeaderRequired: true,
      );
      return DriverModel.fromJson(response);
    } catch (e) {
      log("💥 getDriverVerificationDetails Error: $e");
      rethrow;
    }
  }

  Future<dynamic> verifyDriver(int id, String status, {String? rejectionReason}) async {
    try {
      final data = {
        "status": status,
        if (rejectionReason != null) "rejectionReason": rejectionReason,
      };
      
      final response = await _apiService.putApi(
        url: AppUrl.verifyDriverApi(id),
        data: data,
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 verifyDriver Error: $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // RIDES
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<RideModel>> getAllRides() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getRidesApi,
        isHeaderRequired: true,
      );

      if (response != null && response is List) {
        return response.map((e) => RideModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("💥 getAllRides Error: $e");
      rethrow;
    }
  }

  Future<dynamic> toggleRideSuspicion(int id, bool isSuspicious) async {
    try {
      final response = await _apiService.putApi(
        url: AppUrl.toggleRideSuspicionApi(id),
        data: {"isSuspicious": isSuspicious},
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 toggleRideSuspicion Error: $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // COMPLAINTS
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getComplaintsApi,
        isHeaderRequired: true,
      );

      if (response != null && response is List) {
        return response.map((e) => ComplaintModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      log("💥 getComplaints Error: $e");
      rethrow;
    }
  }

  Future<dynamic> updateComplaintStatus(int id, String status) async {
    try {
      final response = await _apiService.putApi(
        url: AppUrl.updateComplaintStatusApi(id),
        data: {"status": status},
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 updateComplaintStatus Error: $e");
      rethrow;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DASHBOARD & SETTINGS
  // ─────────────────────────────────────────────────────────────────────────

  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getDashboardStatsApi,
        isHeaderRequired: true,
      );
      return DashboardStatsModel.fromJson(response);
    } catch (e) {
      log("💥 getDashboardStats Error: $e");
      rethrow;
    }
  }

  Future<SystemSettingsModel> getSystemSettings() async {
    try {
      final response = await _apiService.getApi(
        url: AppUrl.getSystemSettingsApi,
        isHeaderRequired: true,
      );
      return SystemSettingsModel.fromJson(response);
    } catch (e) {
      log("💥 getSystemSettings Error: $e");
      rethrow;
    }
  }

  Future<dynamic> updateSystemSettings(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.putApi(
        url: AppUrl.updateSystemSettingsApi,
        data: data,
        isHeaderRequired: true,
      );
      return response;
    } catch (e) {
      log("💥 updateSystemSettings Error: $e");
      rethrow;
    }
  }
}
