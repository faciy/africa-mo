import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class SliderPages extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String image;

  const SliderPages(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.description,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBigText(
            text: title,
            size: AppDimensions.font22,
            color: AppColors.primary,
          ),
          SizedBox(
            height: AppDimensions.height40,
          ),
          SvgPicture.asset(
            image,
            width: width * 0.6,
          ),
          SizedBox(
            height: AppDimensions.height20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.width50),
            child: Text(
              description,
              style: TextStyle(
                  height: 1.5,
                  fontSize: AppDimensions.font14,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.7),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: AppDimensions.height60,
          ),
        ],
      ),
    );
  }
}
