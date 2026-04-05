import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_controller.dart';
import '../layouts/responsive_layout.dart';

import 'home_view.dart';
import '../users/users_view.dart';
import '../drivers/drivers_view.dart';
import '../rides/rides_view.dart';
import '../complaints/complaints_view.dart';
import '../settings/settings_view.dart';

class DashboardWrapperView extends StatefulWidget {
  const DashboardWrapperView({super.key});

  @override
  State<DashboardWrapperView> createState() => _DashboardWrapperViewState();
}

class _DashboardWrapperViewState extends State<DashboardWrapperView> {
  int _selectedIndex = 0;
  
  // Register Controller
  final AdminController adminController = Get.put(AdminController());

  final List<Widget> _screens = [
    const HomeView(),
    const UsersView(),
    const DriversView(),
    const RidesView(),
    const ComplaintsView(),
    const SettingsView(),
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
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Settings'),
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
