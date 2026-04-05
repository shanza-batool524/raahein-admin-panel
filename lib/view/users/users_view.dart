import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/user_model.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final AdminController controller = Get.find<AdminController>();

  @override
  void initState() {
    super.initState();
    controller.fetchUsers();
  }

  void _showStatusUpdateDialog(UserModel user) {
    String currentStatus = user.status ?? 'ACTIVE';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status for ${user.firstName ?? 'User'}'),
          content: DropdownButtonFormField<String>(
            initialValue: currentStatus,
            items: const [
              DropdownMenuItem(value: 'ACTIVE', child: Text('ACTIVE')),
              DropdownMenuItem(value: 'SUSPENDED', child: Text('SUSPENDED')),
              DropdownMenuItem(value: 'BANNED', child: Text('BANNED')),
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
                controller.updateUserStatus(user.id, currentStatus);
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
        title: const Text('Manage Users'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.usersList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.usersList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No users found."),
                ElevatedButton(
                  onPressed: () => controller.fetchUsers(),
                  child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: ListView.builder(
            itemCount: controller.usersList.length,
            itemBuilder: (context, index) {
              final user = controller.usersList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('${user.firstName ?? ''} ${user.lastName ?? ''} (${user.role ?? 'USER'})'),
                  subtitle: Text('Phone: ${user.phone ?? 'N/A'}\nStatus: ${user.status ?? 'ACTIVE'}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showStatusUpdateDialog(user),
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
