import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/ride_model.dart';

class RidesView extends StatefulWidget {
  const RidesView({super.key});

  @override
  State<RidesView> createState() => _RidesViewState();
}

class _RidesViewState extends State<RidesView> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    controller.fetchRides();
  }

  void _showSuspicionToggleDialog(RideModel ride) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Toggle Ride Suspicion'),
          content: Text(
            'Current suspicion status: ${ride.isSuspicious}\n\nDo you want to toggle it to ${!ride.isSuspicious}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.toggleRideSuspicion(ride.id, !ride.isSuspicious);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Rides Overview'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.ridesList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ridesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No rides found."),
                ElevatedButton(
                  onPressed: () => controller.fetchRides(),
                  child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRides,
          child: ListView.builder(
            itemCount: controller.ridesList.length,
            itemBuilder: (context, index) {
              final ride = controller.ridesList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: Border.all(
                  color: ride.isSuspicious ? Colors.red : Colors.transparent,
                  width: 2,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ride.isSuspicious ? Colors.red : Colors.green,
                    child: Icon(Icons.directions_car, color: Colors.white),
                  ),
                  title: Text('Ride ID: ${ride.id} - ${ride.status}'),
                  subtitle: Text(
                    'From: ${ride.pickupLocation}\nTo: ${ride.dropoffLocation}\nFare: ${ride.fare ?? "N/A"} PKR',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(
                      ride.isSuspicious ? Icons.warning : Icons.shield_outlined,
                      color: ride.isSuspicious ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => _showSuspicionToggleDialog(ride),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
