import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/templates/security/comptes/messages/show_message_page.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class MessageBienPage extends StatefulWidget {
  const MessageBienPage({Key? key}) : super(key: key);

  @override
  State<MessageBienPage> createState() => _MessageBienPageState();
}

class _MessageBienPageState extends State<MessageBienPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  UtilsController utilsController = Get.put(UtilsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMessage();
    });
  }

  Future<void> loadMessage() async {
    await Get.find<MessageController>().findAllHote(isLoaded: false);
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
              text: "Messages des biens reçus",
              size: AppDimensions.font18,
            ),
            leading: HomeActionWidget(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          body: GetBuilder<MessageController>(builder: (messageController) {
            var messages =
                messageController.messageListHoteModel!.reversed.toList();

            return messages.isEmpty
                ? EmptyPage(
                    text: 'Information',
                    content:
                        'Aucun message pour le moment, veuillez réessayer!',
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
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        var message = messages[index];
                        return Card(
                          child: ListTile(
                            onTap: () async {
                              await messageController
                                  .getConversasion(
                                message.message!.recept_id!,
                                message.message!.bien_id!,
                              )
                                  .then((status) {
                                if (status.isSuccess) {
                                  Get.to(
                                    () => ShowMessagePage(
                                      receptId: message.message!.recept_id!,
                                      bienId: message.message!.bien_id!,
                                    ),
                                    fullscreenDialog: true,
                                  );
                                }
                              });
                            },
                            trailing: message.nb_noread! > 0
                                ? Container(
                                    width: AppDimensions.width20,
                                    height: AppDimensions.height20,
                                    padding: EdgeInsets.all(
                                      AppDimensions.width5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.danger,
                                      borderRadius: BorderRadius.circular(
                                          AppDimensions.radius10),
                                    ),
                                    child: AppSmallText(
                                      text: message.nb_noread.toString(),
                                      color: AppColors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox(),
                            title: AppBigText(
                              text:
                                  '${message.user!.prenoms!} ${message.user!.nom!}',
                              size: AppDimensions.font16,
                              color: AppColors.primary,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSmallText(
                                  text: message.user!.libelle!,
                                  size: AppDimensions.font15,
                                ),
                                AppSmallText(
                                  text: message.message!.message!,
                                  size: AppDimensions.font13,
                                  color: AppColors.black.withOpacity(0.5),
                                ),
                                SizedBox(
                                  height: AppDimensions.height5,
                                ),
                                AppSmallText(
                                  text: utilsController
                                      .formatDate(message.message!.created_at!),
                                  color: AppColors.black.withOpacity(0.5),
                                )
                              ],
                            ),
                            leading: (message.user!.avatar != null)
                                ? CircleAvatar(
                                    radius: AppDimensions.radius20,
                                    backgroundImage: CachedNetworkImageProvider(
                                      message.user!.avatar.toString(),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: AppDimensions.radius20,
                                    backgroundImage: const AssetImage(
                                      AppAssets.AVATAR,
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
