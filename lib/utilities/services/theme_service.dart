import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';

class ThemeService {
  static const Color colorsLight = Colors.white;
  //static const Color colorsDark = Color.fromARGB(255, 68, 68, 68);
  static const Color colorsDark = Color.fromARGB(255, 34, 33, 33);

  final ligthTheme = ThemeData.light().copyWith(
    errorColor: const Color.fromARGB(255, 252, 110, 110),
    scaffoldBackgroundColor: colorsLight,
    primaryColor: AppColors.primary,
    brightness: Brightness.light,
    iconTheme: const IconThemeData(
      color: Colors.black54,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color?>(Colors.black87)),
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: Colors.black87,
      labelColor: AppColors.primary,
      labelStyle: TextStyle(color: AppColors.primary),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: colorsLight,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: GoogleFonts.poppins().fontFamily,
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorsLight,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.black87,
      ),
      centerTitle: true,
      color: colorsLight,
      foregroundColor: Colors.black87,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: colorsLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      type: BottomNavigationBarType.fixed,
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    errorColor: const Color.fromARGB(255, 252, 110, 110),
    scaffoldBackgroundColor: colorsDark,
    primaryColor: AppColors.primary,
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color?>(Colors.white)),
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: AppColors.white,
      labelColor: AppColors.primary,
      labelStyle: TextStyle(color: AppColors.primary),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: colorsDark,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: GoogleFonts.poppins().fontFamily,
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
        ),
    cardColor: colorsDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: colorsDark,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      elevation: 20.0,
      type: BottomNavigationBarType.fixed,
    ),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorsDark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white,
      ),
      centerTitle: true,
      color: colorsDark,
      foregroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  final _getStorage = GetStorage();
  final _darkThemeKey = 'isDarkThemeInnov';

  void saveThemeData(bool isDarkMode) {
    _getStorage.write(_darkThemeKey, isDarkMode);
  }

  bool isSaveDarkMode() {
    return _getStorage.read(_darkThemeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSaveDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSaveDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeData(!isSaveDarkMode());
  }
}
