import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

void showCustomSnackBar(String message,
    {String title = 'Info',
    Color? color = AppColors.white,
    Color? background,
    required String type,
    required BuildContext context,
    Key? key,
    String? position = 'TOP'}) {
  Flushbar(
    key: key,
    titleColor: type == 'error'
        ? AppColors.danger
        : type == 'success'
            ? AppColors.success
            : type == 'info'
                ? AppColors.info
                : AppColors.warning,
    messageColor: type == 'error'
        ? AppColors.danger
        : type == 'success'
            ? AppColors.success
            : type == 'info'
                ? AppColors.info
                : AppColors.warning,
    message: message,
    borderRadius: BorderRadius.circular(AppDimensions.radius10),
    flushbarPosition:
        position == 'TOP' ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
    endOffset: const Offset(0.0, 0.05),
    flushbarStyle: FlushbarStyle.FLOATING,
    margin: EdgeInsets.symmetric(horizontal: AppDimensions.width20),
    padding: EdgeInsets.all(AppDimensions.width10),
    reverseAnimationCurve:
        type == 'error' ? Curves.decelerate : Curves.easeOutCirc,
    forwardAnimationCurve:
        type == 'error' ? Curves.elasticInOut : Curves.easeOutCirc,
    backgroundColor: type == 'error'
        ? const Color.fromARGB(255, 250, 217, 224)
        : type == 'success'
            ? const Color.fromARGB(255, 209, 243, 227)
            : type == 'info'
                ? const Color.fromARGB(255, 211, 240, 243)
                : const Color.fromARGB(255, 252, 242, 227),
    isDismissible: false,
    duration: const Duration(seconds: 5),
    icon: Icon(
      type == 'error'
          ? Icons.error
          : type == 'success'
              ? Icons.check
              : type == 'info'
                  ? Icons.info
                  : Icons.warning,
      color: type == 'error'
          ? AppColors.danger
          : type == 'success'
              ? AppColors.success
              : type == 'info'
                  ? AppColors.info
                  : AppColors.warning,
    ),
    /* showProgressIndicator: true,
    progressIndicatorBackgroundColor: type == 'error'
        ? AppColors.danger
        : type == 'success'
            ? AppColors.success
            : type == 'info'
                ? AppColors.primary
                : AppColors.warning, */
  ).show(context);
}
