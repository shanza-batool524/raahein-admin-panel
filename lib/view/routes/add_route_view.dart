import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/fare_controller.dart';

class AddRouteView extends StatelessWidget {
  const AddRouteView({super.key});

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
              Colors.deepPurple.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.add_road_rounded,
                              color: Colors.deepPurple,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create New Route",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Define city-to-city connections",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      _buildTextField(
                        context: context,
                        controller: controller.fromCityController,
                        focusNode: controller.fromCityFocus,
                        nextFocus: controller.toCityFocus,
                        label: "From City",
                        hint: "e.g. Lahore",
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        context: context,
                        controller: controller.toCityController,
                        focusNode: controller.toCityFocus,
                        label: "To City",
                        hint: "e.g. Islamabad",
                        icon: Icons.flag_outlined,
                      ),
                      const SizedBox(height: 48),
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value 
                            ? null 
                            : () => controller.createRoute(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.deepPurple.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline),
                                  SizedBox(width: 12),
                                  Text(
                                    "Create Route",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                        ),
                      )),
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

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required String label,
    required String hint,
    required IconData icon,
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
          onFieldSubmitted: (_) => nextFocus?.requestFocus(),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
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
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          ),
        ),
      ],
    );
  }
}
