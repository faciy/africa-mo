import 'package:innovimmobilier/services/models/properties/image_model.dart';
import 'package:innovimmobilier/services/models/properties/periode_booking_model.dart';
import 'package:innovimmobilier/services/models/properties/property_model.dart';

class DataPropertyModel {
  bool? statusResponse;
  String? message;
  PropertyModel? bien;
  List<ImageModel>? images;
  List<PeriodeBookingModel>? periodesReservations;

  DataPropertyModel({
    this.statusResponse,
    this.message,
    this.bien,
    this.images,
    this.periodesReservations,
  });

  factory DataPropertyModel.fromMap(Map<String, dynamic> map) {
    return DataPropertyModel(
      statusResponse: map['statusResponse'],
      message: map['message'],
      bien: map['bien'] != null ? PropertyModel.fromJson(map['bien']) : null,
      images: map['images'] != null
          ? List<ImageModel>.from(
              map['images']?.map((x) => ImageModel.fromMap(x)))
          : null,
      periodesReservations: map['periodes_reservations'] != null
          ? List<PeriodeBookingModel>.from(map['periodes_reservations']
              ?.map((x) => PeriodeBookingModel.fromMap(x)))
          : null,
    );
  }

  DataPropertyModel.fromJson(Map<String, dynamic> json) {
    statusResponse = json['statusResponse'];
    message = json['message'];
    bien = json['bien'] != null ? PropertyModel.fromJson(json['bien']) : null;
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    }
    if (json['periodes_reservations'] != null) {
      periodesReservations = <PeriodeBookingModel>[];
      json['periodes_reservations'].forEach((v) {
        periodesReservations!.add(PeriodeBookingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusResponse'] = statusResponse;
    data['message'] = message;
    if (bien != null) {
      data['bien'] = bien!.toJson();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (periodesReservations != null) {
      data['periodes_reservations'] =
          periodesReservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
