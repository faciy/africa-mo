import 'package:innovimmobilier/services/models/properties/image_model.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';

class PropertyResponse {
  bool? status;
  String? message;
  PropertyModel? bien;
  List<ImageModel>? images;

  PropertyResponse({
    this.status,
    this.message,
    this.bien,
    this.images,
  });

  factory PropertyResponse.fromMap(Map<String, dynamic> map) {
    return PropertyResponse(
      status: map['status'],
      message: map['message'],
      bien: map['bien'] != null ? PropertyModel.fromJson(map['bien']) : null,
      images: map['images'] != null
          ? List<ImageModel>.from(
              map['images']?.map((x) => ImageModel.fromMap(x)))
          : null,
    );
  }

  PropertyResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bien = json['bien'] != null ? PropertyModel.fromJson(json['bien']) : null;
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (bien != null) {
      data['bien'] = bien!.toJson();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
