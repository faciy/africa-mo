// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ContentBox extends StatefulWidget {
  String title;
  String content;
  ContentBox({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<ContentBox> createState() => _ContentBoxState();
}

class _ContentBoxState extends State<ContentBox> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHeight = AppDimensions.screenHeight / 5.63;

  @override
  void initState() {
    super.initState();

    if (widget.content.length > textHeight) {
      firstHalf = widget.content.substring(0, textHeight.toInt());
      secondHalf = widget.content
          .substring(textHeight.toInt() + 1, widget.content.length);
    } else {
      firstHalf = widget.content;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxline = 50;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.width20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBigText(
            text: widget.title,
            size: AppDimensions.font20,
          ),
          SizedBox(
            height: AppDimensions.height10,
          ),
          if (secondHalf.isEmpty)
            AppSmallText(
              height: 1.5,
              textAlign: TextAlign.justify,
              text: firstHalf,
              size: AppDimensions.font14,
              maxline: maxline,
            )
          else
            Column(
              children: [
                AppSmallText(
                  height: 1.5,
                  textAlign: TextAlign.justify,
                  text:
                      hiddenText ? ("$firstHalf...") : (firstHalf + secondHalf),
                  size: AppDimensions.font14,
                  maxline: maxline,
                ),
                SizedBox(
                  height: AppDimensions.height10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppSmallText(
                        text: hiddenText ? "En savoir plus" : "Afficher moins",
                        color: AppColors.primary,
                        size: AppDimensions.font14,
                      ),
                      Icon(
                        hiddenText
                            ? Icons.keyboard_arrow_down_outlined
                            : Icons.keyboard_arrow_up_outlined,
                        size: AppDimensions.font18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
