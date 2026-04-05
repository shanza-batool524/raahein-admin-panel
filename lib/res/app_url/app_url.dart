class AppUrl {
  static const String baseUrl = 'https://raaheinbackend-production.up.railway.app/api/v1';

  // Auth
  static const String loginApi = '$baseUrl/auth/login';

  // Admin
  static const String adminBaseUrl = '$baseUrl/admin';

  // Users
  static const String getUsersApi = '$adminBaseUrl/users';
  static String getUserProfileApi(int id) => '$adminBaseUrl/users/$id';
  static String updateUserStatusApi(int id) => '$adminBaseUrl/users/$id/status';

  // Driver Verifications
  static const String getPendingDriverVerificationsApi = '$adminBaseUrl/driver-verifications';
  static String getDriverVerificationDetailsApi(int id) => '$adminBaseUrl/driver-verifications/$id';
  static String verifyDriverApi(int id) => '$adminBaseUrl/driver-verifications/$id/verify';

  // Rides
  static const String getRidesApi = '$adminBaseUrl/rides';
  static String toggleRideSuspicionApi(int id) => '$adminBaseUrl/rides/$id/suspicion';

  // Complaints
  static const String getComplaintsApi = '$adminBaseUrl/complaints';
  static String updateComplaintStatusApi(int id) => '$adminBaseUrl/complaints/$id/status';

  // Dashboard stats
  static const String getDashboardStatsApi = '$adminBaseUrl/dashboard';

  // Settings
  static const String getSystemSettingsApi = '$adminBaseUrl/settings';
  static const String updateSystemSettingsApi = '$adminBaseUrl/settings';
}
