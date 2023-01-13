import 'package:flutter/material.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ModalLoading {
  static Future showLoadingDialog(BuildContext context, String text) async {
    await showDialog(
      barrierDismissible: true, //Don't close dialog when click outside
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            insetAnimationDuration: const Duration(microseconds: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomBtnLoader(
                    width: AppDimensions.width20,
                    height: AppDimensions.height20,
                  ), //Loading Indicator you can use any graphic
                  const SizedBox(
                    height: 10,
                  ),
                  Text(text)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static showAlertDialog(BuildContext context, String text, String type,
      {VoidCallback? onRedirect, String? bntLabel}) async {
    AlertType? alertType;
    String title;
    Color color;
    if (type == "success") {
      alertType = AlertType.success;
      title = "Félicitation";
      color = AppColors.success;
    } else {
      alertType = AlertType.error;
      title = "Erreur";
      color = AppColors.danger;
    }
    Alert(
      context: context,
      type: alertType,
      title: title,
      desc: text,
      style: AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        titleStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.black
              : AppColors.white,
        ),
        descStyle: TextStyle(
          fontSize: AppDimensions.font15,
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.black
              : AppColors.white,
        ),
      ),
      buttons: [
        if (onRedirect != null)
          DialogButton(
            color: color,
            onPressed: onRedirect,
            child: AppSmallText(
              text: bntLabel ?? "Fermer",
              color: AppColors.white,
              size: AppDimensions.font16,
            ),
          )
        else
          DialogButton(
            color: color,
            onPressed: () => Navigator.pop(context),
            child: AppSmallText(
              text: bntLabel ?? "Fermer",
              color: AppColors.white,
              size: AppDimensions.font16,
            ),
          ),
      ],
    ).show();
  }

  static alert(
    BuildContext context,
    String title,
    String text,
    String type, {
    VoidCallback? onRedirect,
    Widget? widget,
    String? libelleSsection,
    bool? barrierDismissible = false,
    String? text2,
  }) async {
    Color color;
    IconData icon;
    if (type == "success") {
      color = AppColors.primary;
      icon = Icons.check;
    } else {
      color = AppColors.danger;
      icon = Icons.close;
    }
    showDialog(
      barrierDismissible: barrierDismissible!,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimensions.radius30),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.width10,
            vertical: AppDimensions.width10,
          ),
          title: AppBigText(
            text: title,
            size: AppDimensions.font18,
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      size: AppDimensions.font20,
                      color: color,
                    ),
                    AppSmallText(
                      text: text,
                      maxline: 10,
                      height: 1.5,
                      textAlign: TextAlign.center,
                      size: AppDimensions.font14,
                    ),
                    if (libelleSsection != null)
                      AppSmallText(
                        text: libelleSsection,
                        maxline: 5,
                        height: 1.5,
                        textAlign: TextAlign.center,
                        size: AppDimensions.font14,
                      ),
                    if (text2 != null)
                      AppSmallText(
                        text: text2,
                        maxline: 5,
                        height: 1.5,
                        color: AppColors.primary,
                        textAlign: TextAlign.center,
                        size: AppDimensions.font14,
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (onRedirect != null)
              TextButton(
                onPressed: onRedirect,
                child: AppBigText(
                  text: 'Fermer',
                  size: AppDimensions.font14,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.primary
                      : AppColors.primaryDark,
                ),
              )
            else
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: AppBigText(
                  text: 'Ok',
                  size: AppDimensions.font14,
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.primary
                      : AppColors.primaryDark,
                ),
              ),
          ],
        );
      },
    );
  }
}
