// ignore_for_file: non_constant_identifier_names

import 'package:innovimmobilier/services/models/messages/message_model.dart';
import 'package:innovimmobilier/services/models/messages/user_model.dart';

class MessageResponse {
  bool? status;
  String? messageText;
  MessageModel? message;
  UserModel? user;
  int? nb_noread;

  MessageResponse({
    this.status,
    this.messageText,
    this.message,
    this.user,
    this.nb_noread,
  });

  factory MessageResponse.fromMap(Map<String, dynamic> map) {
    return MessageResponse(
      status: map['status'],
      messageText: map['messageText'],
      message:
          map['message'] != null ? MessageModel.fromJson(map['message']) : null,
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      nb_noread: map['nb_noread']?.toInt(),
    );
  }

  MessageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messageText = json['messageText'];
    message =
        json['message'] != null ? MessageModel.fromJson(json['message']) : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    nb_noread = json['nb_noread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['messageText'] = messageText;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['nb_noread'] = nb_noread;
    return data;
  }
}
