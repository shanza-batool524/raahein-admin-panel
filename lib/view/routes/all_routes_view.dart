import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fare_controller.dart';
import '../../data/models/route_model.dart';

class AllRoutesView extends StatelessWidget {
  const AllRoutesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FareController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "All Routes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchRoutes(),
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh Routes",
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.routesList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.routesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.route_outlined, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  "No routes found",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.fetchRoutes(),
                  child: const Text("Fetch Routes"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRoutes(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : (MediaQuery.of(context).size.width > 800 ? 2 : 1),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
              ),
              itemCount: controller.routesList.length,
              itemBuilder: (context, index) {
                final route = controller.routesList[index];
                return _buildRouteCard(context, route);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRouteCard(BuildContext context, RouteModel route) {
    final controller = Get.find<FareController>();
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.map, color: Colors.deepPurple, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${route.fromCity} ➔ ${route.toCity}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (route.isActive ?? false) ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (route.isActive ?? false) ? "Active" : "Inactive",
                            style: TextStyle(
                              color: (route.isActive ?? false) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: route.isActive ?? false,
                  onChanged: (value) => controller.toggleRouteStatus(route.id!, value, route.fromCity!, route.toCity!),
                  activeColor: Colors.deepPurple,
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID: #${route.id}",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Fares: ${route.fares?.length ?? 0}",
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple),
                    ),
                  ],
                ),
                Row(
                  children: [
                    /*IconButton(
                      onPressed: () => _showEditDialog(context, route),
                      icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                      tooltip: "Edit Route",
                    ),*/
                    IconButton(
                      onPressed: () => _showDeleteConfirmation(context, route),
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: "Delete Route",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, RouteModel route) {
    final controller = Get.find<FareController>();
    final fromController = TextEditingController(text: route.fromCity);
    final toController = TextEditingController(text: route.toCity);
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit_road_rounded, color: Colors.blueAccent),
            SizedBox(width: 12),
            Text("Edit Route Details"),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: fromController,
                decoration: const InputDecoration(
                  labelText: "From City",
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: toController,
                decoration: const InputDecoration(
                  labelText: "To City",
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back();
                controller.updateRouteDetails(
                  route.id!,
                  fromController.text.trim(),
                  toController.text.trim(),
                  route.isActive ?? false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }


  void _showDeleteConfirmation(BuildContext context, RouteModel route) {
    final controller = Get.find<FareController>();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text("Delete Route"),
          ],
        ),
        content: Text("Are you sure you want to delete the route from ${route.fromCity} to ${route.toCity}? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteRoute(route.id!);
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
}

