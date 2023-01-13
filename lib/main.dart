// ignore_for_file: unused_local_variable, must_be_immutable, depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:innovimmobilier/commons/widgets/notifications/error_page.dart';
import 'package:innovimmobilier/routings/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';

import 'package:innovimmobilier/services/dependencies.dart' as dep;
import 'package:innovimmobilier/utilities/services/theme_service.dart';

  UtilsController utilsController = Get.put(UtilsController());
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await dep.init();
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(const App());
}

class App extends StatefulWidget{
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>   with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // app transitioning to other state.
    } else if (state == AppLifecycleState.paused) {
      // app is on the background.
      utilsController.refreshDatas();
    } else if (state == AppLifecycleState.detached) {
      // flutter engine is running but detached from views
    } else if (state == AppLifecycleState.resumed) {
      // app is visible and running.
      utilsController.refreshDatas();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        locale: const Locale('fr', 'FR'),
        fallbackLocale: const Locale('fr', 'FR'),
        supportedLocales: const [
          Locale('fr', 'FR'),
        ],
        navigatorKey: Get.key,
        themeMode: ThemeService().getThemeMode(),
        debugShowCheckedModeBanner: false,
        theme: ThemeService().ligthTheme,
        darkTheme: ThemeService().darkTheme,
        defaultTransition: Transition.rightToLeft,
        initialRoute: Get.find<UserController>().userLoggedIn()
            ? RouteHelper.getInitialRoute()
            : RouteHelper.getSplashPageRoute(),
        unknownRoute: GetPage(
            name: '/notfound',
            page: () => ErrorPage(
                  text: 'Erreur',
                  content: 'Page non trouvée.',
                )),
        getPages: RouteHelper.routes,
      ),
    );
  }
}
