// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class ApiUri {
  static const String URI = 'https://innov-immobilier.com';
  static const String APP_BASE_URL = '$URI/api';
  static const String APP_UPLOAD = '$URI/public/storage/';

  //Auth endpoints
  static const String APP_LOGIN_URI = '/login';
  static const String APP_USER_PROFIL = '/userAuth';
  static const String APP_USER_EDIT_INFOS = '/updateUser';
  static const String APP_FAVORIS_LIKE_URI = '/like_dislike';
  static const String APP_USER_SORECNI_URI = '/storecni';
  static const String APP_USER_EDIT_PWD = '/updateUserPassword';
  static const String APP_USER_DELETE = '/deleteUserAccount';
  static const String APP_LOGOUT_URI = '/logout';

  //Password Reset endPoints
  static const String APP_RESET_PWD_STEP1_URI = '/reset-password/step1';
  static const String APP_RESET_PWD_STEP2_URI = '/reset-password/step2';
  static const String APP_RESET_PWD_STEP3_URI = '/reset-password/step3';

  //Register endPoints
  static const String APP_REGISTER_GET_CODE_URI = '/register';
  static const String APP_REGISTER_CODE_VERIFY_URI = '/verification';
  static const String APP_REGISTER_CODE_RESEND_URI = '/resend';
  static const String APP_REGISTER_CREATE_PASSWORD_URI = '/create-password';

  //EndPoints des biens
  static const String APP_PROPERTIES_URI = '/biens';
  static const String APP_ADD_PROPERTY_URI = '/biens';
  static const String APP_PROPERTY_EDIT_URI = '/Bienupdate';
  static const String APP_PICTURES_ADD_URI = '/pictures';
  static const String APP_PICTURES_EDIT_URI = '/pictureupdate';
  static const String APP_PICTURES_DELETE_URI = '/pictures';
  static const String APP_TYPE_LIST_URI = '/type-biens';
  static const String APP_COMMUNE_LIST_URI = '/communes';
  static const String APP_BIENS_LIST_BY_TYPE_URI = '/getBiensByType-bien';
  static const String APP_USER_PROPETIES_LIST_URI = '/getMyBiens';

  //EndPoints des messages
  static const String APP_HOTE_MESSAGE_LIST_URI = '/messages_hote';
  static const String APP_CLIENT_MESSAGE_LIST_URI = '/messages_client';
  static const String APP_SEND_MESSAGE_URI = '/send_message';
  static const String APP_CONVERSE_MESSAGE_URI = '/conversation';

  //Notifications
  static const String APP_NOTIFICATION_LIST_URI = '/notifications';
  static const String APP_FIND_NOTIFICATION_URI = '/notification/get';

  //EndPoints des décorations (Dévis)
  static const String APP_SEND_DECORATION_URI = '/decoration';

  //EndPoints des reservation
  static const String APP_BOOKING_URI = '/reservation';
  static const String APP_PAYEMENT_URI = '/payment';
  static const String APP_RESERVATION_URI = '/reservations';

  //EndPoints de recherche
  static const String APP_SEARCH_URI = '/search';

  //EndPoints application
  static const String APP_TAXE_URI = '/taxes';
}
