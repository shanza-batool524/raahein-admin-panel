import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repository/login_repository.dart';
import '../../sessionManger/session_controller.dart';
import '../../view/dashboard/dashboard_wrapper_view.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controller
  final TextEditingController phoneController = TextEditingController();

  // Loading State
  RxBool isLoading = false.obs;

  final LoginRepository _loginRepository = LoginRepository();

  void login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    Map<String, dynamic> data = {
      "phone": phoneController.text.trim(),
    };

    try {
      final response = await _loginRepository.loginApi(data);

      if (response.user != null && response.token != null) {
        // Map the token from the response to the user data before saving
        final userDataWithToken = response.user!.copyWith(token: response.token);

        await SessionController().saveUserPreference(userDataWithToken);

        Get.snackbar(
          "Success",
          "Login successful",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );

        // // Role based navigation mapping
        // if (userDataWithToken.role == 'DRIVER') {
        //   Get.offAllNamed(RouteName.driverDashboardView);
        // } else {
        //   Get.offAllNamed(RouteName.dashboardView);
        // }
        Get.offAll(() => const DashboardWrapperView());
      } else {
        Get.snackbar(
          "Error",
          response.message ?? "Unknown error occurred",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
