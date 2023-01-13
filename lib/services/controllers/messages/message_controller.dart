import 'package:get/get.dart';
import 'package:innovimmobilier/services/models/messages/conversations/conversation_response.dart';
import 'package:innovimmobilier/services/models/messages/message_response.dart';
import 'package:innovimmobilier/services/models/messages/post_message_response.dart';

import 'package:innovimmobilier/services/models/response_model.dart';
import 'package:innovimmobilier/services/repository/messages/message_repository.dart';
import 'package:innovimmobilier/utilities/constants/string.dart';

class MessageController extends GetxController implements GetxService {
  final MessageRepository messageRepository;

  MessageController({required this.messageRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MessageResponse>? _messageListHoteModel = [];
  List<MessageResponse>? get messageListHoteModel => _messageListHoteModel;

  List<MessageResponse>? _messageListClientModel = [];
  List<MessageResponse>? get messageListClientModel => _messageListClientModel;

  ConversationResponse? _conversations;
  ConversationResponse? get conversations => _conversations;

  Future<ResponseModel> findAllHote({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }

    Response response = await messageRepository.findAllHote();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _messageListHoteModel = List.from(response.body)
          .map<MessageResponse>((message) => MessageResponse.fromMap(message))
          .toList();
      responseModel = ResponseModel(true, "Succès");

      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }

    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> findAllClient({bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    update();
    Response response = await messageRepository.findAllClient();
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      _messageListClientModel = List.from(response.body)
          .map<MessageResponse>((message) => MessageResponse.fromMap(message))
          .toList();
      responseModel = ResponseModel(true, "Succès");

      update();
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> getConversasion(int receptId, int bienId,
      {bool isLoaded = true}) async {
    if (isLoaded) {
      _isLoading = true;
      update();
    }
    Response response =
        await messageRepository.getConversasion(receptId, bienId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = ConversationResponse.fromJson(response.body);
      _conversations = bodyResponse;
      responseModel = ResponseModel(true, "Succès");
    } else {
      _conversations = null;
      update();
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    if (isLoaded) {
      _isLoading = false;
      update();
    }
    return responseModel;
  }

  Future<ResponseModel> postMessageHote(
      String message, int bienId, int receptId) async {
    _isLoading = true;
    update();
    Response response =
        await messageRepository.postMessageHote(message, bienId, receptId);
    late ResponseModel responseModel;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = PostMessageResponse.fromJson(response.body);
      if (bodyResponse.status == 'success') {
        await getConversasion(receptId, bienId);
        responseModel = ResponseModel(true, "Message envoyé avec succès.");
        update();
      } else {
        responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
        update();
      }
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postMessageClient(String message, int receptId) async {
    _isLoading = true;
    update();
    Response response =
        await messageRepository.postMessageClient(message, receptId);
    late ResponseModel responseModel;

    if (response.statusCode == 200 || response.statusCode == 201) {
      final bodyResponse = PostMessageResponse.fromJson(response.body);
      if (bodyResponse.status == 'success') {
        await findAllHote();
        await findAllClient();
        responseModel = ResponseModel(true, "Message envoyé avec succès.");
        update();
      } else {
        responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
        update();
      }
    } else {
      responseModel = ResponseModel(false, AppStrings.ERROR_MESSAGE);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
