// ignore_for_file: non_constant_identifier_names

import 'package:innovimmobilier/services/models/messages/conversations/conversation_model.dart';
import 'package:innovimmobilier/services/models/messages/conversations/reception_model.dart';

class ConversationResponse {
  List<ConversationModel>? conversation;
  ReceptionModel? recept;

  ConversationResponse({
    this.conversation,
    this.recept,
  });

  factory ConversationResponse.fromMap(Map<String, dynamic> map) {
    return ConversationResponse(
      conversation: map['conversation'] != null
          ? List<ConversationModel>.from(
              map['conversation']?.map((x) => ConversationModel.fromMap(x)))
          : null,
      recept:
          map['recept'] != null ? ReceptionModel.fromJson(map['recept']) : null,
    );
  }

  ConversationResponse.fromJson(Map<String, dynamic> json) {
    if (json['conversation'] != null) {
      conversation = <ConversationModel>[];
      json['conversation'].forEach((v) {
        conversation!.add(ConversationModel.fromJson(v));
      });
    }
    recept =
        json['recept'] != null ? ReceptionModel.fromJson(json['recept']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.map((v) => v.toJson()).toList();
    }
    if (recept != null) {
      data['recept'] = recept!.toJson();
    }
    return data;
  }
}
