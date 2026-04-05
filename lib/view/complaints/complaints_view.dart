import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/complaint_model.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({super.key});

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    controller.fetchComplaints();
  }

  void _showStatusUpdateDialog(ComplaintModel complaint) {
    String currentStatus = complaint.status ?? 'PENDING';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Complaint #${complaint.id}'),
          content: DropdownButtonFormField<String>(
            initialValue: currentStatus,
            items: const [
              DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
              DropdownMenuItem(value: 'IN_PROGRESS', child: Text('IN_PROGRESS')),
              DropdownMenuItem(value: 'RESOLVED', child: Text('RESOLVED')),
            ],
            onChanged: (val) {
              if (val != null) {
                currentStatus = val;
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateComplaintStatus(complaint.id, currentStatus);
                Navigator.pop(context);
              },
              child: const Text('Update'),
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
        title: const Text('Manage Complaints'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.complaintsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.complaintsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No complaints found."),
                ElevatedButton(
                  onPressed: () => controller.fetchComplaints(),
                  child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchComplaints,
          child: ListView.builder(
            itemCount: controller.complaintsList.length,
            itemBuilder: (context, index) {
              final complaint = controller.complaintsList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.report_problem)),
                  title: Text(complaint.subject),
                  subtitle: Text(
                    'Status: ${complaint.status}\nDesc: ${complaint.description}\nUser ID: ${complaint.userId}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showStatusUpdateDialog(complaint),
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
