import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_link_widget.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';

class AppSectionTitle extends StatelessWidget {
  final String? text;
  final String? actionText;
  final Color? actionColor;
  final Color? color;
  final VoidCallback? onTap;

  const AppSectionTitle({
    Key? key,
    this.onTap,
    this.actionText,
    this.text,
    this.color = Colors.black,
    this.actionColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text != null
            ? AppBigText(
                text: text!,
                size: AppDimensions.font15,
                color: color,
              )
            : const SizedBox(),
        AppLinkWidget(
          onTap: onTap,
          text: actionText,
          color: actionColor,
        ),
      ],
    );
  }
}
