import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/templates/splashs/splash_screen.dart';

class RouteHelper {
  static const String splashPage = '/splash-page';
  static const String welcome = '/welcome';
  static const String initial = '/';

  static String getSplashPageRoute() => splashPage;

  static String getWelcomeRoute() => welcome;

  static String getInitialRoute() => initial;

  static List<GetPage> routes = [
    GetPage(
      name: splashPage,
      page: () => const SplashScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: initial,
      page: () => const InitialHomePage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
