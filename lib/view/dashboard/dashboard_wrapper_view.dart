import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../../controllers/fare_controller.dart';
import '../layouts/responsive_layout.dart';

import 'home_view.dart';
import '../users/users_view.dart';
import '../drivers/drivers_view.dart';
import '../rides/rides_view.dart';
import '../complaints/complaints_view.dart';
import '../routes/add_route_view.dart';
import '../routes/all_routes_view.dart';
import '../fares/add_fare_view.dart';
import '../fares/preview_fare_table_view.dart';
import '../fares/bulk_upload_fares_view.dart';

class DashboardWrapperView extends StatefulWidget {
  const DashboardWrapperView({super.key});

  @override
  State<DashboardWrapperView> createState() => _DashboardWrapperViewState();
}

class _DashboardWrapperViewState extends State<DashboardWrapperView> {
  int _selectedIndex = 0;
  
  // Register Controllers
  final AdminController adminController = Get.put(AdminController());
  final FareController fareController = Get.put(FareController());

  final List<Widget> _screens = [
    const HomeView(),
    const UsersView(),
    const DriversView(),
    const RidesView(),
    const ComplaintsView(),
    const AddRouteView(),
    const AllRoutesView(),
    const AddFareView(),
    const PreviewFareTableView(),
    const BulkUploadFaresView(),
  ];

  final List<NavigationRailDestination> _navDestinations = const [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: Text('Dashboard'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: Text('Users'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.drive_eta_outlined),
      selectedIcon: Icon(Icons.drive_eta),
      label: Text('Drivers'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map),
      label: Text('Rides'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.report_problem_outlined),
      selectedIcon: Icon(Icons.report_problem),
      label: Text('Complaints'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.add_road_outlined),
      selectedIcon: Icon(Icons.add_road),
      label: Text('Add Route'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.route_outlined),
      selectedIcon: Icon(Icons.route),
      label: Text('All Routes'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.paid_outlined),
      selectedIcon: Icon(Icons.paid),
      label: Text('Add Fare'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.table_view_outlined),
      selectedIcon: Icon(Icons.table_view),
      label: Text('Preview Fares'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.upload_file_outlined),
      selectedIcon: Icon(Icons.upload_file),
      label: Text('Bulk Upload'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      web: _buildWebLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raahein Admin'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ...List.generate(_navDestinations.length, (index) {
              return ListTile(
                leading: _selectedIndex == index 
                  ? _navDestinations[index].selectedIcon 
                  : _navDestinations[index].icon,
                title: _navDestinations[index].label,
                selected: _selectedIndex == index,
                onTap: () {
                  _onItemTapped(index);
                  Navigator.pop(context); // close drawer
                },
              );
            }),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildWebLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: _navDestinations,
            extended: MediaQuery.of(context).size.width >= 1000,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.deepPurple),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
