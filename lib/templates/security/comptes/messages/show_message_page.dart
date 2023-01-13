import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/empty_page.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/messages/conversations/conversation_model.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ShowMessagePage extends StatefulWidget {
  final int receptId;
  final int bienId;
  const ShowMessagePage({
    Key? key,
    required this.receptId,
    required this.bienId,
  }) : super(key: key);

  @override
  State<ShowMessagePage> createState() => _ShowMessagePageState();
}

class _ShowMessagePageState extends State<ShowMessagePage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  UtilsController utilsController = Get.put(UtilsController());
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadConersation();
      /* timer = Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) => loadConersation(),
      ); */
    });
  }

  Future<void> loadConersation() async {
    await Get.find<MessageController>().getConversasion(
      widget.receptId,
      widget.bienId,
      isLoaded: false,
    );
  }

  _sendMessage(
      BuildContext context, MessageController messageController) async {
    var receptId = widget.receptId;
    var bienId = widget.bienId;
    String message = _messageController.text.trim();

    if (message.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir vote message svp!",
        type: 'error',
        context: context,
      );
    } else {
      await messageController
          .postMessageHote(message, bienId, receptId)
          .then((status) {
        if (status.isSuccess) {
          showCustomSnackBar(
            status.message,
            type: 'success',
            context: context,
          );
          _messageController.text = '';
          setState(() {});
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
        return GetBuilder<MessageController>(builder: (messageController) {
          var messages = messageController.conversations!;
          var recepteur = messages.recept;

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
              leading: HomeActionWidget(
                color: Theme.of(context).brightness == Brightness.light
                    ? AppColors.black.withOpacity(0.6)
                    : AppColors.white,
              ),
            ),
            body: Stack(
              children: [
                GetBuilder<UserController>(builder: (userController) {
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: AppDimensions.height20,
                        right: AppDimensions.height20,
                        bottom: AppDimensions.height20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (userController.userModel!.avatar != null)
                                CircleAvatar(
                                  radius: AppDimensions.radius15,
                                  backgroundImage: CachedNetworkImageProvider(
                                    recepteur!.avatar.toString(),
                                  ),
                                )
                              else
                                CircleAvatar(
                                  radius: AppDimensions.radius15,
                                  backgroundImage: const AssetImage(
                                    AppAssets.AVATAR,
                                  ),
                                ),
                              SizedBox(
                                width: AppDimensions.width10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppBigText(
                                    text:
                                        "${recepteur!.nom!} ${recepteur.prenoms!}",
                                    size: AppDimensions.font18,
                                  ),
                                  AppSmallText(
                                    text: messages.conversation!.first.libelle!,
                                    size: AppDimensions.font13,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.width10,
                          ),
                          Divider(
                            height: 5,
                            color: AppColors.grey.withOpacity(0.6),
                          ),
                          SizedBox(
                            height: AppDimensions.width20,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: AppDimensions.height20,
                      right: AppDimensions.height20,
                    ),
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: content(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.width20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.cream
                          : AppColors.black,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radius5),
                              color: AppColors.grey.withOpacity(0.3),
                            ),
                            child: FormBuilder(
                              key: _formKey,
                              child: TextFormField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.width10,
                                  ),
                                  hintText: "Votre message...",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppDimensions.width50,
                          child: messageController.isLoading
                              ? CustomBtnLoader()
                              : InkWell(
                                  onTap: () {
                                    _sendMessage(context, messageController);
                                  },
                                  child: Icon(
                                    Icons.send,
                                    size: AppDimensions.font22 + 3,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      } else {
        return const NoConnexion();
      }
    });
  }

  Widget content() {
    return GetBuilder<MessageController>(builder: (messageController) {
      var messages = messageController.conversations!;
      var conversation = messages.conversation;
      var user = Get.find<UserController>().userModel;
      return messages.conversation!.isEmpty
          ? EmptyPage(
              text: "Infos",
              content: "Vous n'avez aucun message pour le moment.",
              isHome: false,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: conversation!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, int index) {
                        var message = conversation[index];
                        return Wrap(
                          alignment: (user!.id != message.user_id)
                              ? WrapAlignment.start
                              : WrapAlignment.end,
                          children: [
                            if (user.id != message.user_id) recepteur(message),
                            if (user.id == message.user_id) expediteur(message),
                            SizedBox(
                              height: AppDimensions.height100,
                            ),
                          ],
                        );
                      }),
                ),
                SizedBox(height: AppDimensions.height200),
              ],
            );
    });
  }

  Widget recepteur(ConversationModel message) {
    return GetBuilder<MessageController>(builder: (messageController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppDimensions.height20,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.all(AppDimensions.width10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radius5),
            ),
            child: AppSmallText(
              text: message.message!,
              maxline: 100,
            ),
          ),
          SizedBox(
            height: AppDimensions.height5,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppSmallText(
                text: utilsController.formatDate(message.created_at!),
              ),
            ),
          )
        ],
      );
    });
  }

  Widget expediteur(ConversationModel message) {
    return GetBuilder<MessageController>(builder: (messageController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: AppDimensions.height10,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            padding: EdgeInsets.all(AppDimensions.width10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radius5),
            ),
            child: AppSmallText(
              text: message.message!,
              maxline: 100,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: AppDimensions.height5,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSmallText(
                text: utilsController.formatDate(message.created_at!),
              ),
            ),
          )
        ],
      );
    });
  }
}
