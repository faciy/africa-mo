// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_link_widget.dart';
import 'package:innovimmobilier/templates/initial_home_page.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class EmptyPage extends StatelessWidget {
  final String? text;
  final String? content;
  String? image;
  bool? isHome = true;
  EmptyPage({
    Key? key,
    this.text,
    this.content,
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
            image != null ? image! : "assets/images/location_search.svg",
            width: AppDimensions.width150,
          ),
          if (text != null)
            SizedBox(
              height: AppDimensions.height20,
            ),
          if (text != null)
            Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.font18,
              ),
            ),
          if (content != null)
            Container(
              padding: EdgeInsets.all(AppDimensions.height40),
              child: Text(
                content!,
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
                    size: AppDimensions.font16,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
