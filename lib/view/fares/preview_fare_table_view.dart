import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fare_controller.dart';

class PreviewFareTableView extends StatelessWidget {
  const PreviewFareTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FareController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("All Available Fares", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              controller.fareSearchQuery.value = "";
              controller.filterVehicleCategory.value = "All";
              controller.filterACStatus.value = null;
              controller.fetchRoutes();
            },
            icon: const Icon(Icons.refresh),
            tooltip: "Reset & Refresh",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.routesList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.routesList.isEmpty) {
          return _buildEmptyState("No routes available");
        }

        // 1. Generate All Rows
        List<FareTableRow> allRows = [];
        for (var route in controller.routesList) {
          if (route.fares != null && route.fares!.isNotEmpty) {
            for (var fare in route.fares!) {
              allRows.add(FareTableRow(
                fareId: fare['id'] ?? 0,
                routeId: route.id ?? 0,
                routeName: "${route.fromCity} ➔ ${route.toCity}",
                category: fare['vehicleCategory']?.toString() ?? "N/A",
                hasAC: fare['hasAC'] ?? false,
                seats: fare['passengerCount'] ?? 0,
                fare: fare['farePerSeat'] ?? 0,
              ));
            }
          }
        }

        // 2. Filter Rows
        final query = controller.fareSearchQuery.value.toLowerCase();
        final selectedCat = controller.filterVehicleCategory.value;
        final acFilter = controller.filterACStatus.value;

        List<FareTableRow> filteredRows = allRows.where((row) {
          final matchesSearch = row.routeName.toLowerCase().contains(query) || 
                               row.category.toLowerCase().contains(query);
          final matchesCategory = selectedCat == "All" || row.category == selectedCat;
          final matchesAC = acFilter == null || row.hasAC == acFilter;
          
          return matchesSearch && matchesCategory && matchesAC;
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(controller),
              const SizedBox(height: 16),
              _buildFilters(controller),
              const SizedBox(height: 24),
              _buildStatsHeader(filteredRows.length, allRows.length),
              const SizedBox(height: 16),
              Expanded(
                child: filteredRows.isEmpty 
                  ? _buildEmptyState("No fares match your search/filters")
                  : _buildTable(context, filteredRows),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar(FareController controller) {
    return TextField(
      onChanged: (val) => controller.fareSearchQuery.value = val,
      decoration: InputDecoration(
        hintText: "Search by route or category...",
        prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildFilters(FareController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Obx(() => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.filterVehicleCategory.value,
                hint: const Text("Category"),
                items: ["All", ...controller.vehicleCategories].map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.replaceAll("_", " ")),
                  );
                }).toList(),
                onChanged: (val) => controller.filterVehicleCategory.value = val!,
              ),
            )),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Obx(() {
              return Row(
                children: [
                  _buildFilterChip("All AC", controller.filterACStatus.value == null, () => controller.filterACStatus.value = null),
                  _buildFilterChip("AC Only", controller.filterACStatus.value == true, () => controller.filterACStatus.value = true),
                  _buildFilterChip("Non-AC", controller.filterACStatus.value == false, () => controller.filterACStatus.value = false),
                ],
              );
            }),
          ),
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: () {
              controller.fareSearchQuery.value = "";
              controller.filterVehicleCategory.value = "All";
              controller.filterACStatus.value = null;
            },
            icon: const Icon(Icons.clear_all, size: 20),
            label: const Text("Clear All"),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: Colors.deepPurple,
        backgroundColor: Colors.grey.shade50,
        pressElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<FareTableRow> rows) {
    final controller = Get.find<FareController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.grey.shade100),
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.deepPurple.shade50),
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text("Route", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Category", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("AC", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Seats", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Fare (PKR)", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: rows.map((row) {
                  return DataRow(cells: [
                    DataCell(Text(row.routeName, style: const TextStyle(fontWeight: FontWeight.w500))),
                    DataCell(Text(row.category.replaceAll("_", " "))),
                    DataCell(Icon(
                      row.hasAC ? Icons.check_circle : Icons.cancel,
                      color: row.hasAC ? Colors.green : Colors.grey,
                      size: 20,
                    )),
                    DataCell(Text(row.seats.toString())),
                    DataCell(Text(
                      "Rs. ${row.fare}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    )),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      onPressed: () => _showDeleteDialog(context, controller, row),
                      tooltip: "Delete Fare",
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FareController controller, FareTableRow row) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text("Delete Fare?"),
          ],
        ),
        content: Text("Are you sure you want to remove the fare for ${row.category} on route ${row.routeName}?\nThis action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteFare(row.fareId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(int filteredCount, int totalCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info_outline, size: 18, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            filteredCount == totalCount 
              ? "Showing all $totalCount active results"
              : "Showing $filteredCount of $totalCount results matching your filters",
            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }
}

class FareTableRow {
  final int fareId;
  final int routeId;
  final String routeName;
  final String category;
  final bool hasAC;
  final int seats;
  final int fare;

  FareTableRow({
    required this.fareId,
    required this.routeId,
    required this.routeName,
    required this.category,
    required this.hasAC,
    required this.seats,
    required this.fare,
  });
}
