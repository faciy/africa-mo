import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/notifications/notification_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();
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
            title: AppSmallText(
              text: "Mes notifications",
              size: AppDimensions.font18,
            ),
            leading: HomeActionWidget(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          body: _listNotifications(),
        );
      } else {
        return const NoConnexion();
      }
    });
  }

  Widget _listNotifications() {
    return GetBuilder<NotificationController>(
        builder: (notificationController) {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          left: AppDimensions.width20,
          right: AppDimensions.width20,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            onTap: () {},
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            title: Text(
              "Le bien que vous avez ajouté à vos favoris est maintenant disponible.",
              style: TextStyle(fontSize: AppDimensions.font14),
            ),
            subtitle: Text(
              "Il y a 1 heure",
              style: TextStyle(fontSize: AppDimensions.font12),
            ),
            leading: const CircleAvatar(
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.notifications_none_outlined,
                color: AppColors.black,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 2,
            color: Colors.black.withOpacity(0.5),
          );
        },
      );
    });
  }
}
