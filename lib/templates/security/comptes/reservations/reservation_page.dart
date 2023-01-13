import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/booking/reservation/reservation_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  UtilsController utilsController = Get.put(UtilsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadReservation();
    });
  }

  Future<void> loadReservation() async {
    await Get.find<ReservationController>().findAll(isLoaded: false);
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
            title: AppSmallText(
              text: "Historique des reservations",
              size: AppDimensions.font18,
            ),
            leading: HomeActionWidget(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          body: GetBuilder<ReservationController>(
              builder: (reservationController) {
            var reservations =
                reservationController.reservations!.reversed.toList();

            return reservations.isEmpty
                ? EmptyPage(
                    text: 'Information',
                    content: "Vous n'avez pas de reservation maintenant",
                  )
                : Container(
                    margin: EdgeInsets.only(
                      top: AppDimensions.height20,
                      left: AppDimensions.width5,
                      right: AppDimensions.width5,
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: reservations.length,
                      itemBuilder: (BuildContext context, int index) {
                        var reservation = reservations[index];
                        return Card(
                          child: ListTile(
                            onTap: () async {},
                            title: AppBigText(
                              text: reservation.bien!.libelle!,
                              size: AppDimensions.font16,
                              color: AppColors.primary,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text:
                                      " Du ${utilsController.formatDate(reservation.reservation!.date_debut!)} au ${utilsController.formatDate(reservation.reservation!.date_fin!)}",
                                  size: AppDimensions.font15,
                                ),
                                AppSmallText(
                                  text: utilsController.currency(
                                      reservation.reservation!.montant!),
                                  size: AppDimensions.font13,
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                            leading: (reservation.bien!.image != null)
                                ? CircleAvatar(
                                    radius: AppDimensions.radius20,
                                    backgroundImage: CachedNetworkImageProvider(
                                      reservation.bien!.image.toString(),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: AppDimensions.radius20,
                                    backgroundImage: const AssetImage(
                                      AppAssets.IMG_EMPTY,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  );
          }),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
