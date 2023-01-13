// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_action_icon.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class HomeActionWidget extends StatelessWidget {
  final Color? color;
  final bool? isHome;
  const HomeActionWidget({super.key, this.color, this.isHome = false});

  @override
  Widget build(BuildContext context) {
    return AppActionIcon(
      icon: Icons.close,
      iconColor: color ?? AppColors.white,
      iconSize: AppDimensions.font22,
      onPress: () {
        if (isHome == true) {
          Get.offAll(const InitialHomePage());
        } else {
          Get.back();
        }
      },
    );
  }
}
