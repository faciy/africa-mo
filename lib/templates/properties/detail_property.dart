// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/content_box.dart';
import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/controllers/properties/favories/favoris_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/properties/image_model.dart';
import 'package:innovimmobilier/services/models/properties/property_response.dart';
import 'package:innovimmobilier/templates/properties/bookings/booking_property.dart';
import 'package:innovimmobilier/templates/properties/send_hote_message_page.dart';
import 'package:innovimmobilier/templates/properties/widgets/category_item.dart';
import 'package:innovimmobilier/utilities/constants/assets.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailProperty extends StatefulWidget {
  final PropertyResponse propertyModel;
  const DetailProperty({Key? key, required this.propertyModel})
      : super(key: key);

  @override
  State<DetailProperty> createState() => _DetailPropertyState();
}

class _DetailPropertyState extends State<DetailProperty> {
  UtilsController utilsController = Get.put(UtilsController());
  final _pageController = PageController();
  bool isExist = false;
  String? libelleTypeBien = "";

  @override
  void initState() {
    super.initState();
    getEtatFavorite();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTypeBien();
    });
  }

  Future<void> getTypeBien() async {
    await Get.find<PropertyTypeController>().findAll();
    var typebiens =
        Get.find<PropertyTypeController>().categoryListModel!.toList();

    for (var typebien in typebiens) {
      if (typebien.id == widget.propertyModel.bien!.typebien_id) {
        setState(() {
          libelleTypeBien = typebien.libelle;
        });
      }
    }
  }

  void getEtatFavorite() {
    var user = Get.find<UserController>().userModel!;
    if (user.favorites != "[]") {
      if (user.favorites != null) {
        var favorites = json.decode(user.favorites);
        if (favorites != null) {
          isExist =
              favorites.containsKey(widget.propertyModel.bien!.id.toString());
          setState(() {});
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertyController>(builder: (propertyController) {
      int maxline = 50;
      var property = propertyController.propertySingle!.first;
      var images = property.images; //widget.propertyModel.images;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Container(
                width: AppDimensions.width30,
                height: AppDimensions.height30,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Transform.translate(
                  offset: const Offset(2, 0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: AppDimensions.font15,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: AppColors.white),
          backgroundColor: AppColors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          elevation: 0,
          actions: [
            GetBuilder<FavorisController>(builder: (favorisController) {
              //var user = Get.find<UserController>().userModel!;
              return IconButton(
                onPressed: () {
                  showCustomSnackBar(
                    "Fonctionalité dans la prochaine MAJ",
                    type: "info",
                    context: context,
                  );
                  /* favorisController
                      .postFavoris(
                    user.email!,
                    property.bien!.id!,
                  )
                      .then((status) {
                    if (status.isSuccess) {
                      getEtatFavorite();
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
                  }); */
                },
                icon: Icon(
                  isExist ? Icons.favorite : Icons.favorite_border_outlined,
                  color: AppColors.white,
                ),
              );
            }),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.save_alt,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          mini: true,
          onPressed: () {
            Get.to(
                () => SendHoteMessagePage(
                      title: "Enoyer un message",
                      propertyModel: widget.propertyModel.bien!,
                    ),
                fullscreenDialog: true);
          },
          child: const Icon(Icons.message),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerBox(images),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: AppDimensions.height20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: AppDimensions.width20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBigText(
                            text: property.bien!.libelle!,
                            size: AppDimensions.font20,
                            maxlines: 2,
                          ),
                          SizedBox(
                            height: AppDimensions.height5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: AppDimensions.font12,
                                color: AppColors.grey.withOpacity(0.8),
                              ),
                              AppSmallText(
                                text: property.bien!.localisation!,
                                size: AppDimensions.font12,
                                color: AppColors.grey.withOpacity(0.8),
                                maxline: 2,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppDimensions.height5,
                          ),
                          if (libelleTypeBien != null)
                            AppSmallText(
                              text: libelleTypeBien!,
                              size: AppDimensions.font15,
                              color: AppColors.grey.withOpacity(0.8),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    Divider(
                      indent: AppDimensions.width20,
                      endIndent: AppDimensions.width20,
                      height: 5,
                      color: AppColors.grey.withOpacity(0.6),
                    ),
                    _equipementList(),
                    Divider(
                      indent: AppDimensions.width20,
                      endIndent: AppDimensions.width20,
                      height: 5,
                      color: AppColors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: AppDimensions.width20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBigText(
                            text: "Description",
                            size: AppDimensions.font20,
                          ),
                          SizedBox(
                            height: AppDimensions.height10,
                          ),
                          AppSmallText(
                            height: 1.5,
                            textAlign: TextAlign.justify,
                            text: property.bien!.description!,
                            size: AppDimensions.font14,
                            maxline: maxline,
                          ),
                          SizedBox(
                            height: AppDimensions.height30,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppBigText(
                                        text: utilsController.currency(
                                          property.bien!.prix.toString(),
                                        ),
                                        size: AppDimensions.font20,
                                      ),
                                      AppSmallText(
                                        text: "/nuit",
                                        size: AppDimensions.font16,
                                        color: AppColors.grey,
                                      ),
                                    ],
                                  ),
                                  AppButtonWidget(
                                    isResponsive: true,
                                    width: AppDimensions.width120,
                                    onTap: () {
                                      Get.to(
                                        () => BookingProperty(
                                            propertyModel: property),
                                        fullscreenDialog: true,
                                      );
                                    },
                                    icon: Icons.calendar_month,
                                    text: "Reserver",
                                    color: AppColors.white,
                                    buttonBorderColor: AppColors.primary,
                                    buttonColor: AppColors.primary,
                                    iconColor: AppColors.white,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppDimensions.height20,
                    ),
                    Divider(
                      indent: AppDimensions.width20,
                      endIndent: AppDimensions.width20,
                      height: 5,
                      color: AppColors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    ContentBox(
                      title: "Situations",
                      content: property.bien!.situation!,
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    Divider(
                      indent: AppDimensions.width20,
                      endIndent: AppDimensions.width20,
                      height: 5,
                      color: AppColors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    ContentBox(
                      title: "Equipements",
                      content: property.bien!.equipement!,
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    Divider(
                      indent: AppDimensions.width20,
                      endIndent: AppDimensions.width20,
                      height: 5,
                      color: AppColors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      height: AppDimensions.height10,
                    ),
                    ContentBox(
                      title: "Conditions",
                      content: property.bien!.condition!,
                    ),
                    SizedBox(
                      height: AppDimensions.height30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _equipementList() {
    return Container(
      height: AppDimensions.height30,
      margin: EdgeInsets.only(
        top: AppDimensions.height20,
        bottom: AppDimensions.height20,
        left: AppDimensions.height20,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: EdgeInsets.only(right: AppDimensions.width20),
            child: CategoryItem(
              color: AppColors.success,
              title: "Facile d'accès - Ascenseur",
              icon: Icons.person,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: AppDimensions.width20),
            child: CategoryItem(
              title: "Parking & Service de sécurité",
              icon: Icons.security,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: AppDimensions.width20),
            child: CategoryItem(
              color: AppColors.primary,
              title: "Connexion wifi",
              icon: Icons.wifi,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: AppDimensions.width20),
            child: CategoryItem(
              color: AppColors.info,
              title: "Téléviseur et Canal",
              icon: Icons.sports_football_sharp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerBox(List<ImageModel>? images) {
    return GetBuilder<PropertyController>(builder: (propertyController) {
      var property = propertyController.propertySingle!.first;
      return SizedBox(
        height: AppDimensions.height300,
        child: images!.isNotEmpty
            ? Stack(children: [
                PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    images.length,
                    (int index) {
                      return images[index].src != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(AppDimensions.radius20),
                                  bottomRight:
                                      Radius.circular(AppDimensions.radius20),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    ApiUri.APP_UPLOAD + images[index].src!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(AppDimensions.radius20),
                                  bottomRight:
                                      Radius.circular(AppDimensions.radius20),
                                ),
                              ),
                              child: Image.asset(AppAssets.IMG_EMPTY),
                            );
                    },
                  ),
                ),
                Positioned(
                  bottom: AppDimensions.height20,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: images.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.white,
                        dotHeight: AppDimensions.height5,
                        dotWidth: AppDimensions.height5 + 1,
                        spacing: AppDimensions.width5,
                      ),
                    ),
                  ),
                ),
              ])
            : property.bien!.image != null
                ? Container(
                    height: AppDimensions.height350,
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          ApiUri.APP_UPLOAD + property.bien!.image!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: AppDimensions.height350,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: Image.asset(AppAssets.IMG_EMPTY),
                  ),
      );
    });
  }
}
