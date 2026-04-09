import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/route_model.dart';
import '../data/models/fare_table_model.dart';
import '../data/repository/fare_repository.dart';

class FareController extends GetxController {
  final FareRepository _repository = FareRepository();

  final fromCityController = TextEditingController();
  final toCityController = TextEditingController();
  final passengerCountController = TextEditingController();
  final farePerSeatController = TextEditingController();

  final fromCityFocus = FocusNode();
  final toCityFocus = FocusNode();
  final passengerCountFocus = FocusNode();
  final farePerSeatFocus = FocusNode();

  var isLoading = false.obs;
  var isTableLoading = false.obs;
  var routesList = <RouteModel>[].obs;

  // Fare related state
  var selectedRouteId = RxnInt();
  var vehicleCategory = "ECONOMY_1000CC".obs;
  var hasAC = false.obs;

  // Preview state
  var selectedPreviewRouteId = RxnInt();
  var fareTableResponse = Rxn<FareTableResponse>();
  
  // Search and Filter state for Preview
  var fareSearchQuery = "".obs;
  var filterVehicleCategory = "All".obs;
  var filterACStatus = RxnBool(); // null: All, true: AC, false: Non-AC

  final List<String> vehicleCategories = [
    "ECONOMY_800CC",
    "ECONOMY_1000CC",
    "ECONOMY_1300CC",
    "DELUXE_1500CC",
    "LUXURY_1800CC",
    "PREMIUM",
    "SUV",
    "HIRO_B",
    "APV"
  ];

  // Bulk Upload State
  var bulkFareItems = <BulkFareItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRoutes();
    addBulkRow(); // Initialize with one row for bulk upload
  }

  Future<void> fetchRoutes() async {
    isLoading.value = true;
    try {
      final routes = await _repository.getRoutes();
      routesList.value = routes;
    } catch (e) {
      _showError("Fetch Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRouteDetails(int id, String fromCity, String toCity, bool isActive) async {
    isLoading.value = true;
    try {
      await _repository.updateRoute(id, {
        "fromCity": fromCity,
        "toCity": toCity,
        "isActive": isActive,
      });
      await Future.delayed(const Duration(milliseconds: 500));
      await fetchRoutes();
      _showSuccess("Route details updated successfully");
    } catch (e) {
      _showError("Update Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleRouteStatus(int id, bool isActive, String fromCity, String toCity) async {
    isLoading.value = true;
    try {
      await _repository.updateRoute(id, {
        "isActive": isActive,
        "fromCity": fromCity,
        "toCity": toCity,
      });
      await Future.delayed(const Duration(milliseconds: 500));
      await fetchRoutes();
      _showSuccess("Route status updated");
    } catch (e) {
      _showError("Update Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRoute(int id) async {
    isLoading.value = true;
    try {
      await _repository.deleteRoute(id);
      await fetchRoutes();
      _showSuccess("Route deleted successfully");
    } catch (e) {
      _showError("Delete Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRoute() async {
    if (fromCityController.text.isEmpty || toCityController.text.isEmpty) {
      _showError("Validation Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    Map<String, dynamic> data = {
      "fromCity": fromCityController.text.trim(),
      "toCity": toCityController.text.trim(),
    };

    try {
      await _repository.createRoute(data);
      _showSuccess("Route Created successfully");
      fromCityController.clear();
      toCityController.clear();
    } catch (e) {
      _showError("API Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFareToRoute() async {
    if (selectedRouteId.value == null) {
      _showError("Validation Error", "Please select a route");
      return;
    }
    if (passengerCountController.text.isEmpty || farePerSeatController.text.isEmpty) {
      _showError("Validation Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;
    Map<String, dynamic> data = {
      "routeId": selectedRouteId.value,
      "vehicleCategory": vehicleCategory.value,
      "hasAC": hasAC.value,
      "passengerCount": int.tryParse(passengerCountController.text) ?? 4,
      "farePerSeat": int.tryParse(farePerSeatController.text) ?? 1000,
    };

    try {
      await _repository.addFare(data);
      _showSuccess("Fare added to route successfully");
      _clearFareInputs();
      await fetchRoutes();
    } catch (e) {
      _showError("API Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFareInputs() {
    selectedRouteId.value = null;
    passengerCountController.clear();
    farePerSeatController.clear();
    hasAC.value = false;
    vehicleCategory.value = "ECONOMY_1000CC";
  }

  Future<void> fetchFareTable(int routeId) async {
    isTableLoading.value = true;
    try {
      final response = await _repository.getFareTable(routeId);
      fareTableResponse.value = response;
    } catch (e) {
      _showError("Preview Error", e.toString());
    } finally {
      isTableLoading.value = false;
    }
  }

  void addBulkRow() {
    bulkFareItems.add(BulkFareItem());
  }

  void removeBulkRow(int index) {
    if (bulkFareItems.length > 1) {
      bulkFareItems[index].dispose();
      bulkFareItems.removeAt(index);
    }
  }

  Future<void> uploadBulkFares() async {
    if (bulkFareItems.isEmpty) return;

    for (var item in bulkFareItems) {
      if (item.fromCity.text.isEmpty || item.toCity.text.isEmpty || 
          item.passengerCount.text.isEmpty || item.farePerSeat.text.isEmpty) {
        _showError("Validation Error", "Please fill all fields for all rows");
        return;
      }
    }

    isLoading.value = true;

    final faresList = bulkFareItems.map((item) => {
      "fromCity": item.fromCity.text.trim(),
      "toCity": item.toCity.text.trim(),
      "vehicleCategory": item.vehicleCategory.value,
      "hasAC": item.hasAC.value,
      "passengerCount": int.tryParse(item.passengerCount.text) ?? 4,
      "farePerSeat": int.tryParse(item.farePerSeat.text) ?? 1000,
    }).toList();

    try {
      final response = await _repository.bulkUploadFares({"fares": faresList});
      String message = "Bulk Upload Success!\nRoutes: ${response['routesCreated']}, Fares: ${response['faresCreated']}";
      _showSuccess(message);
      
      for (var item in bulkFareItems) {
        item.dispose();
      }
      bulkFareItems.clear();
      addBulkRow();
      
      await Future.delayed(const Duration(seconds: 1)); // Wait for backend sync
      await fetchRoutes();
    } catch (e) {
      _showError("Bulk Upload Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFare(int fareId) async {
    isLoading.value = true;
    try {
      await _repository.deleteFare(fareId);
      _showSuccess("Fare removed successfully");
      await fetchRoutes(); // Refresh data to update preview
    } catch (e) {
      _showError("Delete Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    fromCityController.dispose();
    toCityController.dispose();
    passengerCountController.dispose();
    farePerSeatController.dispose();
    fromCityFocus.dispose();
    toCityFocus.dispose();
    passengerCountFocus.dispose();
    farePerSeatFocus.dispose();
    for (var item in bulkFareItems) {
      item.dispose();
    }
    super.onClose();
  }
}

class BulkFareItem {
  final fromCity = TextEditingController();
  final toCity = TextEditingController();
  final passengerCount = TextEditingController();
  final farePerSeat = TextEditingController();
  var vehicleCategory = "ECONOMY_1000CC".obs;
  var hasAC = false.obs;

  void dispose() {
    fromCity.dispose();
    toCity.dispose();
    passengerCount.dispose();
    farePerSeat.dispose();
  }
}
