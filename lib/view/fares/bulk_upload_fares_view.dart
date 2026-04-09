import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fare_controller.dart';

class BulkUploadFaresView extends StatelessWidget {
  const BulkUploadFaresView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FareController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Bulk Fare Upload", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Obx(() => TextButton.icon(
            onPressed: controller.isLoading.value ? null : () => controller.uploadBulkFares(),
            icon: controller.isLoading.value 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.cloud_upload_outlined),
            label: const Text("Upload All"),
          )),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() => ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: controller.bulkFareItems.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.bulkFareItems.length) {
            return _buildAddMoreButton(controller);
          }
          return _buildFareItemCard(context, controller, index);
        },
      )),
    );
  }

  Widget _buildFareItemCard(BuildContext context, FareController controller, int index) {
    final item = controller.bulkFareItems[index];
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade50,
                  radius: 18,
                  child: Text("${index + 1}", style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ),
                if (controller.bulkFareItems.length > 1)
                  IconButton(
                    onPressed: () => controller.removeBulkRow(index),
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallField(
                    controller: item.fromCity,
                    label: "From City",
                    hint: "e.g. Karachi",
                    icon: Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallField(
                    controller: item.toCity,
                    label: "To City",
                    hint: "e.g. Hyderabad",
                    icon: Icons.flag_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildCategoryDropdown(item, controller),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallField(
                    controller: item.passengerCount,
                    label: "Seats",
                    hint: "4",
                    icon: Icons.people_outline,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallField(
                    controller: item.farePerSeat,
                    label: "Fare",
                    hint: "1000",
                    icon: Icons.monetization_on_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildACSwitch(item),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: Colors.deepPurple.shade300),
            filled: true,
            fillColor: Colors.grey.shade50,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(BulkFareItem item, FareController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Category", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 4),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: item.vehicleCategory.value,
              onChanged: (val) => item.vehicleCategory.value = val!,
              items: controller.vehicleCategories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat.replaceAll("_", " "), style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildACSwitch(BulkFareItem item) {
    return Obx(() => Row(
      children: [
        Icon(Icons.ac_unit, size: 18, color: item.hasAC.value ? Colors.blue : Colors.grey),
        const SizedBox(width: 8),
        const Text("Air Conditioning", style: TextStyle(fontSize: 13)),
        const Spacer(),
        Switch(
          value: item.hasAC.value,
          onChanged: (val) => item.hasAC.value = val,
          activeColor: Colors.blue,
        ),
      ],
    ));
  }

  Widget _buildAddMoreButton(FareController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: OutlinedButton.icon(
        onPressed: () => controller.addBulkRow(),
        icon: const Icon( Icons.add_circle_outline),
        label: const Text("Add Another Fare Row"),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: const BorderSide(color: Colors.deepPurple, style: BorderStyle.solid),
        ),
      ),
    );
  }
}
