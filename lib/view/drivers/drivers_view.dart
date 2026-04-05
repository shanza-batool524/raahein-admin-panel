import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/driver_model.dart';

class DriversView extends StatefulWidget {
  const DriversView({super.key});

  @override
  State<DriversView> createState() => _DriversViewState();
}

class _DriversViewState extends State<DriversView> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    controller.fetchPendingDrivers();
  }

  void _showVerdictDialog(DriverModel driver) {
    showDialog(
      context: context,
      builder: (context) {
        String reason = '';
        return AlertDialog(
          title: const Text('Verify Driver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to verify or reject this driver?'),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rejection Reason (if rejecting)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => reason = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                if (reason.isEmpty) {
                  Get.snackbar('Error', 'Reason required for rejection');
                  return;
                }
                controller.verifyDriver(driver.id, 'REJECTED', reason: reason);
                Navigator.pop(context);
              },
              child: const Text('Reject', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                controller.verifyDriver(driver.id, 'VERIFIED');
                Navigator.pop(context);
              },
              child: const Text('Approve', style: TextStyle(color: Colors.white)),
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
        title: const Text('Pending Driver Verifications'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.pendingDriversList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.pendingDriversList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No pending drivers found."),
                ElevatedButton(
                  onPressed: () => controller.fetchPendingDrivers(),
                  child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchPendingDrivers,
          child: ListView.builder(
            itemCount: controller.pendingDriversList.length,
            itemBuilder: (context, index) {
              final driver = controller.pendingDriversList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: const CircleAvatar(child: Icon(Icons.drive_eta)),
                  title: Text('Driver ID: ${driver.id} - User ID: ${driver.userId}'),
                  subtitle: Text('Status: ${driver.verificationStatus}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (driver.user != null)
                            Text('Name: ${driver.user?.firstName} ${driver.user?.lastName}'),
                          if (driver.user != null)
                            Text('Phone: ${driver.user?.phone}'),
                          if (driver.details != null)
                            Text('CNIC: ${driver.details?.cnic} | License: ${driver.details?.licenseNumber}'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _showVerdictDialog(driver),
                                icon: const Icon(Icons.gavel),
                                label: const Text('Provide Verdict'),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
