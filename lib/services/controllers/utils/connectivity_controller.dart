import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var connectionType = "".obs;
  final Connectivity connectivity = Connectivity();
  late StreamSubscription streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getConnectionStatus();
    streamSubscription =
        connectivity.onConnectivityChanged.listen(getConnectionType);
  }

  void getConnectionStatus() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await connectivity.checkConnectivity();

      getConnectionType(connectivityResult);
    } catch (e) {
      Get.snackbar("Erreur", "Vérifiez votre connexion internet");
    }
  }

  void getConnectionType(connectivityResult) {
    if (connectivityResult == ConnectivityResult.wifi) {
      connectionType.value = "wifi";
    } else if (connectivityResult == ConnectivityResult.mobile) {
      connectionType.value = "mobile";
    } else {
      connectionType.value = "none";
    }
  }
}
