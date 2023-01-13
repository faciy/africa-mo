// ignore_for_file: non_constant_identifier_names

class ImageModel {
  int? id;
  int? bien_id;
  int? status;
  int? valid;
  String? src;
  String? created_at;
  String? updated_at;

  ImageModel({
    this.src,
    this.id,
    this.bien_id,
    this.status,
    this.valid,
    this.created_at,
    this.updated_at,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      bien_id: map['bien_id'],
      status: map['status'],
      valid: map['valid'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      src: map['src'],
    );
  }

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bien_id = json['bien_id'];
    status = json['status'];
    valid = json['valid'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bien_id'] = bien_id;
    data['status'] = status;
    data['valid'] = valid;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    data['src'] = src;
    return data;
  }
}
