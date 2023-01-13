// ignore_for_file: library_prefixes

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;
import 'package:innovimmobilier/utilities/constants/constants.dart';
import 'dart:convert' as convert;

class LocationServiceController extends GetxController implements GetxService {
  final String key = AppConstants.GOOGLE_API_KEY;
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place';
  Completer<GoogleMapController> myMapController = Completer();
  late GooglePlace googlePlace;
  late Position position;
  late double _lat;
  late double _lng;
  bool isLoading = false;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  List<AutocompletePrediction> predictions = [];

  double get lat => _lat;
  double get lng => _lng;
  late LatLng _currentPoint;
  LatLng get currentPoint => _currentPoint;

  Set<Marker> marker = {};
  LatLng? _markerPosition;
  LatLng? get markerPosition => _markerPosition;

  @override
  void onInit() {
    super.onInit();
    determinePosition();
    googlePlace = GooglePlace(AppConstants.GOOGLE_API_KEY);
    _lat = 0.0;
    _lng = 0.0;
  }

  @override
  void onClose() {
    cleanMarer();
    super.onClose();
  }

  void autocompleteSearch(String value, mounted) async {
    isLoading = true;
    update();
    var result =
        await googlePlace.autocomplete.get(value, region: 'CI', language: 'fr');
    if (result != null && result.predictions != null && mounted) {
      predictions = result.predictions!;
      update();
    }
    isLoading = false;
    update();
  }

  Future<String> getPlaceId(String input) async {
    final String url =
        '$baseUrl/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = '$baseUrl/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var result = json['result'] as Map<String, dynamic>;
    return result;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _lat = position.latitude;
    _lng = position.longitude;
    _currentPoint = LatLng(position.latitude, position.longitude);
    update();
    return position;
  }

  void onMapCreated(GoogleMapController controller) async {
    if (!myMapController.isCompleted) {
      myMapController.complete(controller);
    } else {}
    update();
  }

  void cleanMarer() {
    marker.clear();
    marker = {};
    update();
  }

  void getPosition() {
    Get.back();
  }

  Future<void> setMarker(LatLng latLng, {int? id}) async {
    cleanMarer();
    marker.add(
      Marker(
        markerId: id != null ? MarkerId(id.toString()) : const MarkerId('mark'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: latLng,
      ),
    );
    _markerPosition = latLng;

    await onAnimateCamera(latLng);
    update();
  }

  Future<void> onAnimateCamera(LatLng latLng) async {
    final GoogleMapController controller = await myMapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          tilt: 50.0,
          bearing: 45.0,
          zoom: 12.0,
        ),
      ),
    );
    update();
  }
}
