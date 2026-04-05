import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'res/routes/routes.dart';
import 'res/routes/routes_name.dart';
import 'sessionManger/session_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Raahein Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: RouteName.splashScreen,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashNavigator(),
        ),
        ...AppRoutes.appRoutes(),
      ],
    );
  }
}

class SplashNavigator extends StatefulWidget {
  const SplashNavigator({super.key});

  @override
  State<SplashNavigator> createState() => _SplashNavigatorState();
}

class _SplashNavigatorState extends State<SplashNavigator> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final session = SessionController();
    await session.getUserPreference();

    // Minor delay for smoother UX
    await Future.delayed(const Duration(milliseconds: 500)); 

    if (session.isLogin && session.userDataModel.token != null) {
      Get.offAllNamed(RouteName.dashboardWrapperView);
    } else {
      Get.offAllNamed(RouteName.loginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

