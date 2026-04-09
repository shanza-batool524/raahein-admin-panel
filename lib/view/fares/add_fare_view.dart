import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fare_controller.dart';

class AddFareView extends StatelessWidget {
  const AddFareView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FareController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Card(
                elevation: 20,
                shadowColor: Colors.deepPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 40),
                      _buildRouteDropdown(controller),
                      const SizedBox(height: 24),
                      _buildVehicleCategoryDropdown(controller),
                      const SizedBox(height: 24),
                      _buildACSwitch(controller),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              controller: controller.passengerCountController,
                              focusNode: controller.passengerCountFocus,
                              nextFocus: controller.farePerSeatFocus,
                              label: "Passenger Count",
                              hint: "e.g. 4",
                              icon: Icons.people_outline,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _buildTextField(
                              context: context,
                              controller: controller.farePerSeatController,
                              focusNode: controller.farePerSeatFocus,
                              label: "Fare Per Seat",
                              hint: "e.g. 1500",
                              icon: Icons.monetization_on_outlined,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      _buildSubmitButton(controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.add_card_rounded,
            color: Colors.blue,
            size: 32,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Fare to Route",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Set pricing details for specific routes",
                style: TextStyle(color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDropdown(FareController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Route",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              hint: const Text("Choose a route"),
              value: controller.selectedRouteId.value,
              onChanged: (val) => controller.selectedRouteId.value = val,
              items: controller.routesList.map((route) {
                return DropdownMenuItem<int>(
                  value: route.id,
                  child: Text("${route.fromCity} ➔ ${route.toCity}"),
                );
              }).toList(),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildVehicleCategoryDropdown(FareController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Vehicle Category",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: controller.vehicleCategory.value,
              onChanged: (val) => controller.vehicleCategory.value = val!,
              items: controller.vehicleCategories.map((cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat.replaceAll("_", " ")),
                );
              }).toList(),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildACSwitch(FareController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.ac_unit, color: Colors.blueAccent),
              SizedBox(width: 12),
              Text(
                "Air Conditioning (AC)",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Obx(() => Switch(
            value: controller.hasAC.value,
            onChanged: (val) => controller.hasAC.value = val,
            activeColor: Colors.blueAccent,
          )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onFieldSubmitted: (_) => nextFocus?.requestFocus(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue.shade300),
            filled: true,
            fillColor: Colors.grey.shade50,
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FareController controller) {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.isLoading.value 
          ? null 
          : () => controller.addFareToRoute(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.blueAccent.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: controller.isLoading.value
          ? const CircularProgressIndicator(color: Colors.white)
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline),
                SizedBox(width: 12),
                Text(
                  "Add Fare",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
      ),
    ));
  }
}
