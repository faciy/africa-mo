// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_link_widget.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class SuccessPage extends StatelessWidget {
  final String text;
  final String content;
  String? image;
  bool? isHome = true;
  SuccessPage({
    Key? key,
    required this.text,
    required this.content,
    this.image,
    this.isHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image != null ? image! : "assets/images/payment_success.svg",
            width: AppDimensions.width150,
          ),
          SizedBox(
            height: AppDimensions.height20,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppDimensions.font18,
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppDimensions.height40),
            child: Text(
              content,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.font14,
              ),
            ),
          ),
          isHome != false
              ? SizedBox(
                  child: AppLinkWidget(
                    onTap: () => Get.off(() => const InitialHomePage()),
                    text: "Retournez à l'accueil",
                    size: AppDimensions.font20,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
