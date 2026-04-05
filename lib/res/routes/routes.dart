import 'package:get/get.dart';
import '../../view/dashboard/dashboard_wrapper_view.dart';
import '../../view/login/login_view.dart';
import 'routes_name.dart';

class AppRoutes {
  static appRoutes() => [
      GetPage(
        name: RouteName.loginView,
        page: () => const LoginView(),
        transitionDuration: const Duration(milliseconds: 250),
        transition: Transition.leftToRightWithFade,
      ),
        GetPage(
          name: RouteName.dashboardWrapperView,
          page: () => const DashboardWrapperView(),
          transitionDuration: const Duration(milliseconds: 250),
          transition: Transition.leftToRightWithFade,
        ),
      ];
}
