// ignore_for_file: must_be_immutable

import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/favorite/favorite_screen.dart';
import 'package:innovimmobilier/templates/home/home_screen.dart';
import 'package:innovimmobilier/templates/search/explorer_screen.dart';
import 'package:innovimmobilier/templates/security/comptes/compte_screen.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class InitialHomePage extends StatefulWidget {
  const InitialHomePage({Key? key}) : super(key: key);

  @override
  State<InitialHomePage> createState() => _InitialHomePageState();
}

class _InitialHomePageState extends State<InitialHomePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    const HomeScreen(),
    const ExplorerScreen(),
    const FavoriteScreen(),
    const CompteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<UserController>(builder: (userController) {
          return Scaffold(
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black54.withOpacity(0.1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor:
                    Theme.of(context).brightness == Brightness.light
                        ? AppColors.cream
                        : AppColors.black.withOpacity(0.5),
                currentIndex: currentIndex,
                selectedItemColor: AppColors.primary,
                unselectedItemColor:
                    Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.5)
                        : AppColors.white,
                elevation: 10,
                selectedFontSize: AppDimensions.font14,
                unselectedFontSize: AppDimensions.font14,
                onTap: onTap,
                items: const [
                  BottomNavigationBarItem(
                    label: "Accueil",
                    icon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    label: "Explorer",
                    icon: Icon(Icons.search),
                  ),
                  BottomNavigationBarItem(
                    label: "Favoris",
                    icon: Icon(Icons.favorite_border_outlined),
                  ),
                  BottomNavigationBarItem(
                    label: "Compte",
                    icon: Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),
            body: pages[currentIndex],
          );
        });
      } else {
        return const NoConnexion();
      }
    });
  }
}
