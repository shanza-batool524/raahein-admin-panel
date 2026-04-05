import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    controller.fetchDashboardStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
        automaticallyImplyLeading: false, // For desktop mainly
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.dashboardStats.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = controller.dashboardStats.value;

        if (stats == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Failed to load stats."),
                ElevatedButton(
                  onPressed: () => controller.fetchDashboardStats(),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDashboardStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Platform Metrics",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    _buildStatCard("Total Users", stats.totalUsers.toString(), Colors.blue),
                    _buildStatCard("Banned Users", stats.bannedUsers.toString(), Colors.red),
                    _buildStatCard("Total Drivers", stats.totalDrivers.toString(), Colors.green),
                    _buildStatCard("Pending Drivers", stats.pendingDrivers.toString(), Colors.orange),
                    _buildStatCard("Total Rides", stats.totalRides.toString(), Colors.purple),
                    _buildStatCard("Completed Rides", stats.completedRides.toString(), Colors.teal),
                    _buildStatCard("Cancelled Rides", stats.cancelledRides.toString(), Colors.deepOrange),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
