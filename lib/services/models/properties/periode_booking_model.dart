// ignore_for_file: non_constant_identifier_names

class PeriodeBookingModel {
  String? start;
  String? end;

  PeriodeBookingModel({
    this.start,
    this.end,
  });

  factory PeriodeBookingModel.fromMap(Map<String, dynamic> map) {
    return PeriodeBookingModel(
      start: map['start'],
      end: map['end'],
    );
  }

  PeriodeBookingModel.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
