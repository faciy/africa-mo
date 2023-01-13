// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/custom_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_action_icon.dart';
import 'package:innovimmobilier/commons/widgets/item_list.dart';
import 'package:innovimmobilier/commons/widgets/no_connexion.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/connectivity_controller.dart';
import 'package:innovimmobilier/templates/security/authentication/login_page.dart';
import 'package:innovimmobilier/templates/security/comptes/helps/help_page.dart';
import 'package:innovimmobilier/templates/security/comptes/messages/message_bien_page.dart';
import 'package:innovimmobilier/templates/security/comptes/messages/message_support_page.dart';
import 'package:innovimmobilier/templates/security/comptes/profiles/profile_page.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/add_property_page.dart';
import 'package:innovimmobilier/templates/security/comptes/properties/properties_list_page.dart';
import 'package:innovimmobilier/templates/security/comptes/reservations/reservation_page.dart';
import 'package:innovimmobilier/templates/security/comptes/securities/delete_account_page.dart';
import 'package:innovimmobilier/templates/security/comptes/securities/security_page.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:innovimmobilier/utilities/services/theme_service.dart';

class CompteScreen extends StatefulWidget {
  const CompteScreen({Key? key}) : super(key: key);

  @override
  State<CompteScreen> createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> {
  ConnectivityController connectivityController =
      Get.put(ConnectivityController());
  @override
  Widget build(BuildContext context) {
    const moonIcon = CupertinoIcons.moon_stars;
    const ligthIcon = CupertinoIcons.sun_max_fill;
    return Obx(() {
      if (connectivityController.connectionType.value != 'none') {
        return GetBuilder<UserController>(builder: (userController) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
                statusBarBrightness:
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light,
                statusBarColor: Theme.of(context).brightness == Brightness.light
                    ? AppColors.white
                    : AppColors.dark,
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: AppDimensions.width20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppActionIcon(
                        icon: Theme.of(context).brightness == Brightness.light
                            ? moonIcon
                            : ligthIcon,
                        iconColor:
                            Theme.of(context).brightness == Brightness.light
                                ? null
                                : AppColors.warning,
                        onPress: () {
                          ThemeService().changeTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: AppDimensions.height20,
                    right: AppDimensions.height20,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const ProfilePage());
                        },
                        child: Row(
                          children: [
                            if (userController.userModel != null &&
                                userController.userModel!.avatar != null)
                              CircleAvatar(
                                radius: AppDimensions.radius35,
                                backgroundImage: CachedNetworkImageProvider(
                                  userController.userModel!.avatar.toString(),
                                ),
                              )
                            else
                              CircleAvatar(
                                radius: AppDimensions.radius35,
                                backgroundImage: const AssetImage(
                                  AppAssets.AVATAR,
                                ),
                              ),
                            SizedBox(
                              width: AppDimensions.width20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppBigText(
                                  maxlines: 2,
                                  text:
                                      "${userController.userModel!.nom!} ${userController.userModel!.prenoms!}",
                                  size: AppDimensions.font16,
                                ),
                                AppSmallText(
                                  text: (userController.userModel!.role_id ==
                                          AppConstants.HOTE_ROLE)
                                      ? "Hôte"
                                      : (userController.userModel!.role_id ==
                                              AppConstants.ADMIN_ROLE)
                                          ? "Administrateur"
                                          : "Client",
                                  size: AppDimensions.font15,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      partOne(userController),
                      partTwo(userController),
                    ],
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

  Widget partOne(UserController userController) {
    return Column(
      children: [
        SizedBox(
          height: AppDimensions.width20,
        ),
        Divider(
          height: 5,
          color: AppColors.grey.withOpacity(0.6),
        ),
        SizedBox(
          height: AppDimensions.width20,
        ),
        if (userController.userModel!.role_id == AppConstants.HOTE_ROLE)
          ItemList(
            icon: Icons.add_home_outlined,
            title: "Déposer un bien",
            onTap: () {
              Get.to(() => const AddPropertyPage());
            },
          ),
        if (userController.userModel!.role_id == AppConstants.HOTE_ROLE)
          ItemList(
            icon: Icons.list,
            title: "Gérer mes biens",
            onTap: () {
              Get.to(
                () => PropertiesListPage(
                  title: "Gérer mes biens",
                ),
              );
            },
          ),
        if (userController.userModel!.role_id == AppConstants.HOTE_ROLE)
          ItemList(
            icon: Icons.message,
            title: "Mes messages",
            onTap: () {
              Get.to(
                () => const MessageBienPage(),
              );
            },
          ),
        ItemList(
          icon: Icons.calendar_month,
          title: "Mes reservations",
          onTap: () {
            Get.to(
              () => const ReservationPage(),
            );
          },
        ),
        /* ItemList(
          icon: Icons.weekend_outlined,
          title: "Décoration d'intérieur",
          onTap: () {
            Get.to(() => DecorationPage(title: "Décoration d'intérieur"));
          },
        ),
        ItemList(
          icon: Icons.real_estate_agent_outlined,
          title: "Investissement",
          onTap: () {
            Get.to(() => InvestissementPage(title: "Projet d'investissement"));
          },
        ), 
        SizedBox(
          height: AppDimensions.width20,
        ),*/
      ],
    );
  }

  Widget partTwo(UserController userController) {
    return Column(
      children: [
        if (userController.userModel!.role_id == AppConstants.HOTE_ROLE)
          SizedBox(
            height: AppDimensions.width20,
          ),
        if (userController.userModel!.role_id == AppConstants.HOTE_ROLE)
          Divider(
            height: 5,
            color: AppColors.grey.withOpacity(0.6),
          ),
        SizedBox(
          height: AppDimensions.width20,
        ),
        ItemList(
          icon: Icons.email_outlined,
          title: "Contacter le support",
          onTap: () {
            Get.to(() => const MessageSupportPage(
                  title: "Contacter le support",
                ));
          },
        ),
        /* ItemList(
          icon: Icons.notifications,
          title: "Mes notifications",
          onTap: () {
            Get.to(() => const NotificationPage());
          },
        ), */
        ItemList(
          icon: Icons.quick_contacts_mail_outlined,
          title: "Informations personnelles",
          onTap: () {
            Get.to(() => const ProfilePage());
          },
        ),
        ItemList(
          icon: Icons.shield_outlined,
          title: "Connexion et Sécurité",
          onTap: () {
            Get.to(() => const SecurityPage());
          },
        ),
        ItemList(
          icon: Icons.error_outline,
          title: "Centre d'aide",
          onTap: () {
            Get.to(() => const HelpPage());
          },
        ),
        ItemList(
          color: AppColors.danger,
          icon: Icons.lock,
          title: "Supprimer mon compte",
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: AppBigText(
                    text: 'Attention suppression de compte',
                    maxlines: 2,
                    size: AppDimensions.font18,
                  ),
                  content: AppSmallText(
                    text: 'Etes vous sûr de vouloir supprimer votre compte?',
                    size: AppDimensions.font13,
                    maxline: 3,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: AppBigText(
                        text: 'Non',
                        size: AppDimensions.font14,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.primary
                            : AppColors.primaryDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.to(
                          () => const DeleteAccountPage(),
                        );
                      },
                      child: AppBigText(
                        text: 'Oui, continuer',
                        size: AppDimensions.font14,
                        color: Theme.of(context).brightness == Brightness.light
                            ? AppColors.primary
                            : AppColors.primaryDark,
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
        GetBuilder<UserController>(builder: (userController) {
          return userController.isLoading
              ? const CustomLoader()
              : ItemList(
                  icon: Icons.logout_outlined,
                  title: "Déconnexion",
                  onTap: () async {
                    await userController.logout(isLoaded: true).then((status) {
                      if (status.isSuccess) {
                        Get.offAll(() => LoginPage(
                              isHome: true,
                            ));
                        showCustomSnackBar(
                          status.message,
                          type: "success",
                          context: context,
                        );
                      } else {
                        showCustomSnackBar(
                          status.message,
                          type: "error",
                          context: context,
                        );
                      }
                    });
                  },
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.danger
                      : AppColors.warning,
                  isTraining: false,
                );
        }),
      ],
    );
  }
}

class ItemSwitch extends StatefulWidget {
  final String title;
  bool isActive = false;
  Function(bool?)? onChange;
  ItemSwitch({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onChange,
  }) : super(key: key);

  @override
  State<ItemSwitch> createState() => _ItemSwitchState();
}

class _ItemSwitchState extends State<ItemSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppSmallText(
          text: widget.title,
          size: AppDimensions.font16,
        ),
        Switch(
          value: widget.isActive,
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
