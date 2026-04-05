import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../data/models/system_settings_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final AdminController controller = Get.find<AdminController>();

  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController baseFareCtrl;
  late TextEditingController perKmRateCtrl;
  late TextEditingController surgeMultiplierCtrl;
  late TextEditingController safetyMessageCtrl;
  late TextEditingController announcementCtrl;

  @override
  void initState() {
    super.initState();
    baseFareCtrl = TextEditingController();
    perKmRateCtrl = TextEditingController();
    surgeMultiplierCtrl = TextEditingController();
    safetyMessageCtrl = TextEditingController();
    announcementCtrl = TextEditingController();

    // Fetch on init
    controller.fetchSystemSettings().then((_) {
      final stats = controller.systemSettings.value;
      if (stats != null) {
        baseFareCtrl.text = stats.baseFare.toString();
        perKmRateCtrl.text = stats.perKmRate.toString();
        surgeMultiplierCtrl.text = stats.surgeMultiplier.toString();
        safetyMessageCtrl.text = stats.safetyMessage ?? '';
        announcementCtrl.text = stats.announcement ?? '';
      }
    });
  }

  @override
  void dispose() {
    baseFareCtrl.dispose();
    perKmRateCtrl.dispose();
    surgeMultiplierCtrl.dispose();
    safetyMessageCtrl.dispose();
    announcementCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      controller.updateSystemSettings({
        "baseFare": double.tryParse(baseFareCtrl.text) ?? 50.0,
        "perKmRate": double.tryParse(perKmRateCtrl.text) ?? 15.0,
        "surgeMultiplier": double.tryParse(surgeMultiplierCtrl.text) ?? 1.0,
        "safetyMessage": safetyMessageCtrl.text,
        "announcement": announcementCtrl.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.systemSettings.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pricing Config',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: baseFareCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Base Fare (PKR)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: perKmRateCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Per Km Rate (PKR)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: surgeMultiplierCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Surge Multiplier',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Communication',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: safetyMessageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Safety Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: announcementCtrl,
                  decoration: const InputDecoration(
                    labelText: 'System Announcement',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    child: const Text('Save Settings', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
