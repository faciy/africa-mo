import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:innovimmobilier/commons/widgets/app_small_text.dart';
import 'package:innovimmobilier/commons/widgets/home_action_widget.dart';
import 'package:innovimmobilier/services/controllers/locations/location_service_controller.dart';
import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';

class ShowMap extends StatefulWidget {
  const ShowMap({Key? key}) : super(key: key);

  @override
  State<ShowMap> createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationServiceController locationController =
      Get.put(LocationServiceController());
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: AppConstants.INIT_POSITION,
    tilt: 50.0,
    bearing: 45.0,
    zoom: 11.0,
  );
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationServiceController>(
      builder: (mapController) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: HomeActionWidget(
              isHome: true,
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
              statusBarBrightness:
                  Theme.of(context).brightness == Brightness.light
                      ? Brightness.dark
                      : Brightness.light,
            ),
            centerTitle: true,
            title: AppSmallText(
              text: "Choisisse la location du bien",
              size: AppDimensions.font18,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              mapController.getPosition();
            },
            icon: const Icon(Icons.save),
            label: Container(
              margin: EdgeInsets.only(
                left: AppDimensions.width20,
                right: AppDimensions.width20,
              ),
              child: AppSmallText(
                text: "Enregistrer l'adresse",
                size: AppDimensions.font15,
              ),
            ),
          ),
          body: Column(
            children: [
              AppSmallText(
                  text: "Cliquez sur la map pour sélectionner le lieu du bien"),
              SizedBox(
                height: AppDimensions.height10,
              ),
              Expanded(
                child: GoogleMap(
                  zoomControlsEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  trafficEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) async {
                    mapController.onMapCreated(controller);
                  },
                  markers: mapController.marker,
                  onTap: (LatLng latLng) {
                    mapController.cleanMarer();
                    mapController.setMarker(latLng);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
