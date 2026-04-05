class DashboardStatsModel {
  final int totalUsers;
  final int bannedUsers;
  final int totalDrivers;
  final int pendingDrivers;
  final int totalRides;
  final int completedRides;
  final int cancelledRides;

  DashboardStatsModel({
    required this.totalUsers,
    required this.bannedUsers,
    required this.totalDrivers,
    required this.pendingDrivers,
    required this.totalRides,
    required this.completedRides,
    required this.cancelledRides,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final users = json['users'] ?? {};
    final drivers = json['drivers'] ?? {};
    final rides = json['rides'] ?? {};

    return DashboardStatsModel(
      totalUsers: users['total'] ?? 0,
      bannedUsers: users['banned'] ?? 0,
      totalDrivers: drivers['total'] ?? 0,
      pendingDrivers: drivers['pending'] ?? 0,
      totalRides: rides['total'] ?? 0,
      completedRides: rides['completed'] ?? 0,
      cancelledRides: rides['cancelled'] ?? 0,
    );
  }
}
