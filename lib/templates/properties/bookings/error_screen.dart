// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/commons/widgets/notifications/success_page.dart';
import 'package:innovimmobilier/services/controllers/booking/booking_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';

class ErrorScreen extends StatefulWidget {
  final int? amount;
  final transactionId;
  final bool? isHome;
  const ErrorScreen(
      {this.amount, this.transactionId, this.isHome = false, Key? key})
      : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  bool? isHome;
  @override
  void initState() {
    super.initState();
    isHome = widget.isHome;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      savePayment();
    });
  }

  void savePayment() async {
    if (widget.transactionId != null) {
      await Get.find<BookingController>()
          .payement(widget.transactionId)
          .then((status) {
        if (status.isSuccess) {
          showCustomSnackBar(
            status.message,
            type: 'success',
            context: context,
          );
        } else {
          showCustomSnackBar(
            status.message,
            type: 'error',
            context: context,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Theme.of(context).brightness == Brightness.light
                  ? AppColors.white
                  : AppColors.dark,
              statusBarIconBrightness:
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
              statusBarBrightness:
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
            ),
            centerTitle: true,
            title: const Text('Paiement effectué'),
            leading: HomeActionWidget(
              isHome: isHome,
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          body: SuccessPage(
            text: "Félicitation",
            content:
                "Votre paiement de ${widget.amount} Fcfa a été recu avec succès et l'ID de la transaction est ${widget.transactionId}",
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
