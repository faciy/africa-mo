// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ActionEtat extends StatefulWidget {
  final String text;
  String? type;
  VoidCallback? onPress;
  ActionEtat({
    Key? key,
    required this.text,
    this.onPress,
    this.type = "success",
  }) : super(key: key);

  @override
  State<ActionEtat> createState() => _ActionEtatState();
}

class _ActionEtatState extends State<ActionEtat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: AppDimensions.width30,
          right: AppDimensions.width30,
          bottom: AppDimensions.width70,
        ),
        child: AppButtonWidget(
          icon: Icons.logout,
          onTap: widget.onPress,
          text: "Fermer",
          color: AppColors.white,
          iconColor: AppColors.white,
          buttonBorderColor:
              widget.text == "success" ? AppColors.primary : AppColors.danger,
          buttonColor:
              widget.text == "success" ? AppColors.primary : AppColors.danger,
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: AppDimensions.width30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.type == "success")
                Container(
                  width: AppDimensions.width70,
                  height: AppDimensions.height70,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.radius35),
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Icon(
                      Icons.check,
                      size: AppDimensions.font36 + 64,
                      color: AppColors.success,
                    ),
                  ),
                )
              else
                Container(
                  width: AppDimensions.width70,
                  height: AppDimensions.height70,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.radius35),
                  ),
                  child: Transform.translate(
                    offset: const Offset(-10, -10),
                    child: Icon(
                      Icons.close,
                      size: AppDimensions.font36 + 55,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              SizedBox(
                height: AppDimensions.height12,
              ),
              AppBigText(
                textAlign: TextAlign.center,
                text: widget.text,
                size: AppDimensions.font18,
                maxlines: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
