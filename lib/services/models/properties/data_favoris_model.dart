import 'package:innovimmobilier/services/models/properties/property_model.dart';

class DataFavorisModel {
  List<PropertyModel>? bien;

  DataFavorisModel({
    this.bien,
  });

  factory DataFavorisModel.fromMap(Map<String, dynamic> map) {
    return DataFavorisModel(
      bien: map['bien'] != null
          ? List<PropertyModel>.from(
              map['bien']?.map((x) => PropertyModel.fromMap(x)))
          : null,
    );
  }

  DataFavorisModel.fromJson(Map<String, dynamic> json) {
    if (json['bien'] != null) {
      bien = <PropertyModel>[];
      json['bien'].forEach((v) {
        bien!.add(PropertyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bien != null) {
      data['bien'] = bien!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
