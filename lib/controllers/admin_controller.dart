import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../data/models/driver_model.dart';
import '../data/models/ride_model.dart';
import '../data/models/complaint_model.dart';
import '../data/models/dashboard_stats_model.dart';
import '../data/repository/admin_repository.dart';

class AdminController extends GetxController {
  final AdminRepository _repository = AdminRepository();

  // Observables
  var isLoading = false.obs;
  
  var usersList = <UserModel>[].obs;
  var pendingDriversList = <DriverModel>[].obs;
  var ridesList = <RideModel>[].obs;
  var complaintsList = <ComplaintModel>[].obs;
  
  var dashboardStats = Rxn<DashboardStatsModel>();

  // Fetch Dashboard Stats
  Future<void> fetchDashboardStats() async {
    _setLoading(true);
    try {
      final stats = await _repository.getDashboardStats();
      dashboardStats.value = stats;
    } catch (e) {
      _showError("Failed to fetch dashboard stats", e);
    } finally {
      _setLoading(false);
    }
  }

  // Fetch Users
  Future<void> fetchUsers() async {
    _setLoading(true);
    try {
      final users = await _repository.getUsers();
      usersList.value = users;
    } catch (e) {
      _showError("Failed to fetch users", e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserStatus(int id, String status) async {
    try {
      await _repository.updateUserStatus(id, status);
      await fetchUsers();
      _showSuccess("User status updated");
    } catch (e) {
      _showError("Failed to update status", e);
    }
  }

  // Fetch Drivers
  Future<void> fetchPendingDrivers() async {
    _setLoading(true);
    try {
      final drivers = await _repository.getPendingDriverVerifications();
      pendingDriversList.value = drivers;
    } catch (e) {
      _showError("Failed to fetch drivers", e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyDriver(int id, String status, {String? reason}) async {
    try {
      await _repository.verifyDriver(id, status, rejectionReason: reason);
      await fetchPendingDrivers();
      _showSuccess("Driver verification updated");
    } catch (e) {
      _showError("Failed to update driver", e);
    }
  }

  // Fetch Rides
  Future<void> fetchRides() async {
    _setLoading(true);
    try {
      final rides = await _repository.getAllRides();
      ridesList.value = rides;
    } catch (e) {
      _showError("Failed to fetch rides", e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleRideSuspicion(int id, bool isSuspicious) async {
    try {
      await _repository.toggleRideSuspicion(id, isSuspicious);
      await fetchRides();
      _showSuccess("Ride suspicion toggled");
    } catch (e) {
      _showError("Failed to toggle suspicion", e);
    }
  }

  // Fetch Complaints
  Future<void> fetchComplaints() async {
    _setLoading(true);
    try {
      final complaints = await _repository.getComplaints();
      complaintsList.value = complaints;
    } catch (e) {
      _showError("Failed to fetch complaints", e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateComplaintStatus(int id, String status) async {
    try {
      await _repository.updateComplaintStatus(id, status);
      await fetchComplaints();
      _showSuccess("Complaint status updated");
    } catch (e) {
      _showError("Failed to update complaint", e);
    }
  }



  // Helpers
  void _setLoading(bool value) {
    // only toggle on or off if different
    isLoading.value = value;
  }

  void _showError(String title, Object e) {
    Get.snackbar(
      title,
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _showSuccess(String title) {
    Get.snackbar(
      "Success",
      title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
