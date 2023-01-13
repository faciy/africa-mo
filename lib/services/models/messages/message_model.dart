// ignore_for_file: non_constant_identifier_names

class MessageModel {
  int? id;
  int? user_id;
  int? bien_id;
  int? recept_id;
  int? lecture;
  int? valid;
  int? status;
  String? message;
  String? date_envoi;
  String? date_lecture;
  String? created_at;
  String? updated_at;

  MessageModel({
    this.id,
    this.user_id,
    this.bien_id,
    this.recept_id,
    this.lecture,
    this.valid,
    this.status,
    this.message,
    this.date_envoi,
    this.date_lecture,
    this.created_at,
    this.updated_at,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      user_id: map['user_id'],
      bien_id: map['bien_id'],
      recept_id: map['recept_id'],
      lecture: map['lecture'],
      valid: map['valid'],
      status: map['status'],
      message: map['message'],
      date_envoi: map['date_envoi'],
      date_lecture: map['date_lecture'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );
  }

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    bien_id = json['bien_id'];
    recept_id = json['recept_id'];
    lecture = json['lecture'];
    valid = json['valid'];
    status = json['status'];
    message = json['message'];
    date_envoi = json['date_envoi'];
    date_lecture = json['date_lecture'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = user_id;
    data['bien_id'] = bien_id;
    data['recept_id'] = recept_id;
    data['lecture'] = lecture;
    data['valid'] = valid;
    data['status'] = status;
    data['message'] = message;
    data['created_at'] = date_envoi;
    data['updated_at'] = date_lecture;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    return data;
  }
}
