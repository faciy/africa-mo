import 'package:innovimmobilier/routings/api_uri.dart';
import 'package:innovimmobilier/services/api/api_client.dart';
import 'package:innovimmobilier/services/controllers/booking/booking_controller.dart';
import 'package:innovimmobilier/services/controllers/booking/reservation/reservation_controller.dart';
import 'package:innovimmobilier/services/controllers/decorations/decoration_controller.dart';
import 'package:innovimmobilier/services/controllers/locations/location_service_controller.dart';
import 'package:innovimmobilier/services/controllers/messages/message_controller.dart';
import 'package:innovimmobilier/services/controllers/notifications/notification_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/commune_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/communes/searchs/search_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/favories/favoris_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/property_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/types/property_type_controller.dart';
import 'package:innovimmobilier/services/controllers/properties/taxes/taxe_controller.dart';
import 'package:innovimmobilier/services/controllers/security/authentication/login_controller.dart';
import 'package:innovimmobilier/services/controllers/security/authentication/reset_password_controller.dart';
import 'package:innovimmobilier/services/controllers/security/registration/register_controller.dart';
import 'package:innovimmobilier/services/controllers/security/users/user_controller.dart';
import 'package:innovimmobilier/services/controllers/utils/utils_controller.dart';
import 'package:get/get.dart';
import 'package:innovimmobilier/services/repository/booking/booking_repository.dart';
import 'package:innovimmobilier/services/repository/booking/reservation/reservation_repository.dart';
import 'package:innovimmobilier/services/repository/decorations/decoration_repository.dart';
import 'package:innovimmobilier/services/repository/messages/message_repository.dart';
import 'package:innovimmobilier/services/repository/notifications/notification_repository.dart';
import 'package:innovimmobilier/services/repository/properties/communes/commune_repository.dart';
import 'package:innovimmobilier/services/repository/properties/favories/favoris_repository.dart';
import 'package:innovimmobilier/services/repository/properties/property_repository.dart';
import 'package:innovimmobilier/services/repository/properties/types/property_type_repository.dart';
import 'package:innovimmobilier/services/repository/properties/searchs/search_repository.dart';
import 'package:innovimmobilier/services/repository/properties/taxes/taxe_repository.dart';
import 'package:innovimmobilier/services/repository/security/login_repository.dart';
import 'package:innovimmobilier/services/repository/security/register_repository.dart';
import 'package:innovimmobilier/services/repository/security/reset_password_repository.dart';
import 'package:innovimmobilier/services/repository/security/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferencies = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharedPreferencies);
  Get.lazyPut(() => UtilsController());
  Get.lazyPut(() => LocationServiceController());

  //Api Client
  Get.lazyPut(
    () => ApiClient(
      appBaseUrl: ApiUri.APP_BASE_URL,
      sharedPreferences: Get.find(),
    ),
  );

  //Repositories
  Get.lazyPut(
    () => LoginRepository(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => UserRepository(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => RegisterRepository(
        apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => ResetPasswordRepository(
        apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => PropertyRepository(
        apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => PropertyTypeRepository(
        apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () =>
        SearchRepository(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () =>
        CommuneRepository(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => TaxeRepository(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(
    () => FavorisRepository(apiClient: Get.find()),
  );
  Get.lazyPut(() => BookingRepository(apiClient: Get.find()));
  Get.lazyPut(() => ReservationRepository(apiClient: Get.find()));
  Get.lazyPut(() => MessageRepository(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepository(apiClient: Get.find()));
  Get.lazyPut(() => DecorationRepository(apiClient: Get.find()));

  //Controllers
  Get.lazyPut(() => LoginController(
        loginRepository: Get.find(),
        userRepository: Get.find(),
      ));
  Get.lazyPut(() => UserController(userRepository: Get.find()));
  Get.lazyPut(
    () => RegisterController(
      registerRepository: Get.find(),
      userRepository: Get.find(),
      loginRepository: Get.find(),
    ),
  );
  Get.lazyPut(
    () => ResetPasswordController(resetPasswordRepository: Get.find()),
  );
  Get.lazyPut(() => PropertyController(propertyRepository: Get.find()));
  Get.lazyPut(() => SearchController(searchRepository: Get.find()));
  Get.lazyPut(() => FavorisController(favorisRepository: Get.find()));
  Get.lazyPut(() => PropertyTypeController(propertyTypeRepository: Get.find()));
  Get.lazyPut(() => CommuneController(communeRepository: Get.find()));
  Get.lazyPut(() => TaxeController(taxeRepository: Get.find()));
  Get.lazyPut(() => BookingController(bookingRepository: Get.find()));
  Get.lazyPut(() => ReservationController(reservationRepository: Get.find()));
  Get.lazyPut(() => MessageController(messageRepository: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepository: Get.find()));
  Get.lazyPut(() => DecorationController(decorationRepository: Get.find()));
}
