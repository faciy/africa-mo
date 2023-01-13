import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_textarea_field.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class MessageSupportPage extends StatefulWidget {
  final String? title;
  const MessageSupportPage({Key? key, this.title}) : super(key: key);

  @override
  State<MessageSupportPage> createState() => _MessageSupportPageState();
}

class _MessageSupportPageState extends State<MessageSupportPage> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  _sendMessage(BuildContext context, MessageController messageController) {
    var receptId = 1; //Get.find<UserController>().userModel!.id!;
    String message = _messageController.text.trim();

    if (message.isEmpty) {
      showCustomSnackBar(
        "Veuillez saisir vote message svp!",
        type: 'error',
        context: context,
      );
    } else {
      messageController.postMessageClient(message, receptId).then((status) {
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
              text: widget.title!,
              size: AppDimensions.font15,
            ),
            leading: HomeActionWidget(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColors.black.withOpacity(0.6)
                  : AppColors.white,
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: AppDimensions.height100,
                    left: AppDimensions.height20,
                    right: AppDimensions.height20,
                  ),
                  child: FormBuilder(
                    key: _formKey,
                    child: AppTextareaField(
                        textEditingController: _messageController,
                        maxline: 10,
                        name: "message",
                        hintText: "Sasissez votre message ici..."),
                  ),
                ),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                GetBuilder<MessageController>(builder: (messageController) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: messageController.isLoading
                          ? CustomBtnLoader()
                          : AppButtonWidget(
                              isResponsive: true,
                              onTap: () {
                                _sendMessage(context, messageController);
                              },
                              buttonBorderColor: AppColors.primary,
                              buttonColor: AppColors.primary,
                              iconColor: AppColors.white,
                              color: AppColors.white,
                              icon: Icons.send,
                              text: "Envoyer le message",
                            ));
                }),
              ],
            ),
          ),
        );
      } else {
        return const NoConnexion();
      }
    });
  }
}
