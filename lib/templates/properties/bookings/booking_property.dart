// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/commons/animations/delayed_animation.dart';
import 'package:innovimmobilier/commons/custom_btn_loader.dart';
import 'package:innovimmobilier/commons/show_custom_snack_bar.dart';
import 'package:innovimmobilier/commons/widgets/app_big_text.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/buttons/app_buttons_widget.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/commons/widgets/inputs/app_date_field.dart';
import 'package:innovimmobilier/services/controllers/booking/booking_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/taxes/taxe_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:innovimmobilier/services/models/booking/booking_model.dart';
import 'package:innovimmobilier/services/models/properties/property_response.dart';
import 'package:innovimmobilier/templates/properties/bookings/success_screen.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view.dart';

class BookingProperty extends StatefulWidget {
  PropertyResponse propertyModel;
  BookingProperty({Key? key, required this.propertyModel}) : super(key: key);

  @override
  State<BookingProperty> createState() => _BookingPropertyState();
}

class _BookingPropertyState extends State<BookingProperty> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _startSejourController = TextEditingController();
  final TextEditingController _endSejourController = TextEditingController();
  bool _isAccept = false;
  bool _isEnable = false;
  String initStartDate = '';
  String initEndDate = '';
  dynamic total = 0;
  dynamic totalTaxe = 0;
  dynamic nbreJour = 0;

  @override
  void initState() {
    super.initState();
  }

  static successCallback(response, context) {
    Navigator.pop(context);

    Get.offAll(
      () => SuccessScreen(
        amount: response['requestData']['amount'],
        transactionId: response['transactionId'],
      ),
    );
  }

  _sendData(BuildContext context, BookingController bookingController) async {
    var user = Get.find<UserController>().userModel!;
    var startDate = _startSejourController.text;
    var endDate = _endSejourController.text;
    var totalJour = nbreJour;

    BookingModel booking = BookingModel(
      startSejour: startDate,
      endSejour: endDate,
      nbreSejour: totalJour,
      propertyName: widget.propertyModel.bien!.libelle,
      propertyPrice: int.parse(widget.propertyModel.bien!.prix.toString()),
      propertyId: int.parse(widget.propertyModel.bien!.id.toString()),
      userId: user.id,
      total: total,
    );
    setState(() {});

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: AppBigText(
            text: 'Confirmation',
            size: AppDimensions.font18,
          ),
          content:
              GetBuilder<BookingController>(builder: (reservationController) {
            return reservationController.isLoading
                ? CustomBtnLoader()
                : AppSmallText(
                    text: 'Confirmez-vous la reservation?',
                    size: AppDimensions.font13,
                    maxline: 3,
                  );
          }),
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
                bookingController.save(booking).then((status) {
                  if (status.isSuccess) {
                    var kkiapay = KKiaPay(
                      amount: booking.total!.toInt(),
                      countries: const ["CI"],
                      name: "${user.nom} ${user.prenoms}",
                      email: user.email,
                      data: booking.toString(),
                      reason: "Réservation du bien : ${booking.propertyName}",
                      sandbox: AppConstants.APP_KKIAPAY_SANDBOX,
                      apikey: AppConstants.APP_KKIAPAY_KEY,
                      callback: successCallback,
                      theme: '#3A8F92', // Ex : "#222F5A",
                      /* paymentMethods: const ["momo", "card"], */
                    );

                    Get.to(() => kkiapay);

                    showCustomSnackBar(
                      status.message,
                      type: 'success',
                      context: context,
                    );
                  } else {
                    Get.back();
                    showCustomSnackBar(
                      status.message,
                      type: 'error',
                      context: context,
                    );
                  }
                });
              },
              child: AppBigText(
                text: 'Oui, Réserver',
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
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: HomeActionWidget(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.black.withOpacity(0.6)
              : AppColors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).brightness == Brightness.light
              ? AppColors.white
              : AppColors.dark,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          statusBarBrightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
        ),
        elevation: 0,
        title: AppBigText(
          text: "Réservation",
          size: AppDimensions.font16,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(AppDimensions.width20),
        child: DelayedAnimation(
          delay: 900,
          child: GetBuilder<BookingController>(builder: (bookingController) {
            return AppButtonWidget(
              onTap: _isAccept
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        _isAccept
                            ? _sendData(context, bookingController)
                            : null;
                      }
                    }
                  : () {},
              size: AppDimensions.font16,
              text: "Vérifier et réserver ce bien",
              icon: Icons.check,
              color: _isAccept
                  ? AppColors.white
                  : AppColors.black.withOpacity(0.6),
              iconColor: _isAccept
                  ? AppColors.white
                  : AppColors.black.withOpacity(0.6),
              buttonColor: _isAccept ? AppColors.primary : AppColors.grey,
              buttonBorderColor: _isAccept ? AppColors.primary : AppColors.grey,
              width: MediaQuery.of(context).size.width,
            );
          }),
        ),
      ),
      body: GetBuilder<TaxeController>(builder: (taxeController) {
        var taxe = taxeController.taxeListModel!.first;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(
              top: AppDimensions.height50,
              left: AppDimensions.height20,
              right: AppDimensions.height20,
            ),
            child: FormBuilder(
              key: _formKey,
              onChanged: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isAccept = true;
                  });
                } else {
                  setState(() {
                    _isAccept = false;
                  });
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DelayedAnimation(
                    delay: 100,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AppDateField(
                        textEditingController: _startSejourController,
                        name: "start_sejour",
                        label: "Début du séjour",
                        onChange: (value) {
                          setState(() {
                            initStartDate = value.toString();
                            _isEnable = true;
                            var startDate = DateTime.parse(value.toString());
                            var endDate = initEndDate.isNotEmpty
                                ? DateTime.parse(initEndDate)
                                : DateTime.now();
                            nbreJour = daysBetween(startDate, endDate);
                            var subTotal = nbreJour! *
                                int.parse(widget.propertyModel.bien!.prix!
                                    .toString());
                            totalTaxe = (taxe.valeur! * subTotal / 100);
                            total = nbreJour! *
                                    int.parse(widget.propertyModel.bien!.prix!
                                        .toString()) +
                                totalTaxe;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                  DelayedAnimation(
                    delay: 100,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: AppDateField(
                        enabled: _isEnable,
                        textEditingController: _endSejourController,
                        name: "end_sejour",
                        label: "Fin du séjour",
                        onChange: (value) {
                          initEndDate = value.toString();
                          var startDate = initEndDate.isNotEmpty
                              ? DateTime.parse(initStartDate)
                              : DateTime.now();
                          var endDate = DateTime.parse(value.toString());
                          nbreJour = daysBetween(startDate, endDate);
                          var subTotal = nbreJour! *
                              int.parse(
                                  widget.propertyModel.bien!.prix!.toString());
                          totalTaxe = (taxe.valeur! * subTotal / 100);
                          total = nbreJour! *
                                  int.parse(widget.propertyModel.bien!.prix!
                                      .toString()) +
                              totalTaxe;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                  /* AppBigText(
                  text: "Nombre de nuit",
                  size: AppDimensions.font16,
                ),
                SizedBox(
                  height: AppDimensions.height10,
                ),
                GetBuilder<UtilsController>(builder: (utilsController) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _nbreJourController.text =
                        utilsController.increment.toString();
                  });

                  return AppIncrementField(
                    onIncrement: () {
                      utilsController.setIncrement();
                      setState(() {
                        total = utilsController.increment *
                            int.parse(
                                widget.propertyModel.bien!.prix.toString());
                      });
                    },
                    onDecrement: () {
                      utilsController.setDecrement();
                    },
                    isActive: utilsController.incrementIsActive,
                    controller: _nbreJourController,
                  );
                }),
                SizedBox(
                  height: AppDimensions.height20,
                ),
                Divider(
                  height: 5,
                  color: AppColors.grey.withOpacity(0.6),
                ), */
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                  AppBigText(
                    text: "Détails du prix",
                    size: AppDimensions.font18,
                  ),
                  SizedBox(
                    height: AppDimensions.height15,
                  ),
                  GetBuilder<UtilsController>(builder: (utilsController) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppSmallText(
                              text:
                                  "${utilsController.currency(widget.propertyModel.bien!.prix.toString())} /nuit",
                              size: AppDimensions.font18,
                            ),
                            AppSmallText(
                              text: "${nbreJour!} nuit(s)",
                              size: AppDimensions.font18,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppDimensions.height15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppSmallText(
                              text: "${taxe.libelle} ${taxe.valeur}%",
                              size: AppDimensions.font14,
                            ),
                            AppBigText(
                              text: utilsController
                                  .currency(totalTaxe.toString()),
                              size: AppDimensions.font18,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppDimensions.height15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppSmallText(
                              text: "Total",
                              size: AppDimensions.font18,
                            ),
                            AppBigText(
                              text: utilsController.currency(total.toString()),
                              size: AppDimensions.font18,
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: AppDimensions.height10,
                  ),
                  Divider(
                    height: 5,
                    color: AppColors.grey.withOpacity(0.6),
                  ),
                  SizedBox(
                    height: AppDimensions.height20,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
