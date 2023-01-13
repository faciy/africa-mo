import 'package:innovimmobilier/services/models/properties/type_model.dart';

class DataTypeModel {
  dynamic status;
  String? message;
  TypeModel? categorie;

  DataTypeModel({
    this.status,
    this.message,
    this.categorie,
  });

  factory DataTypeModel.fromMap(Map<String, dynamic> map) {
    return DataTypeModel(
      status: map['status'],
      message: map['message'],
      categorie: map['categorie'] != null
          ? TypeModel.fromJson(map['categorie'])
          : null,
    );
  }

  DataTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    categorie = json['categorie'] != null
        ? TypeModel.fromJson(json['categorie'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (categorie != null) {
      data['bien'] = categorie!.toJson();
    }
    return data;
  }
}
