// ignore_for_file: non_constant_identifier_names

class ReservationModel {
  int? id;
  String? date_debut;
  String? date_fin;
  int? number_nuit;
  int? bien_id;
  int? user_id;
  int? status;
  int? valid;
  String? created_at;
  String? updated_at;
  dynamic montant;

  ReservationModel({
    this.date_debut,
    this.date_fin,
    this.number_nuit,
    this.bien_id,
    this.user_id,
    this.status,
    this.valid,
    this.created_at,
    this.updated_at,
    this.montant,
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      date_debut: map['date_debut'],
      date_fin: map['date_fin'],
      number_nuit: map['number_nuit'],
      bien_id: map['bien_id'],
      user_id: map['user_id'],
      status: map['status'],
      valid: map['valid'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      montant: map['montant'],
    );
  }

  ReservationModel.fromJson(Map<String, dynamic> json) {
    date_debut = json['date_debut'];
    date_fin = json['date_fin'];
    number_nuit = json['number_nuit'];
    bien_id = json['bien_id'];
    user_id = json['user_id'];
    status = json['status'];
    valid = json['valid'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    montant = json['montant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_debut'] = date_debut;
    data['date_fin'] = date_fin;
    data['number_nuit'] = number_nuit;
    data['bien_id'] = bien_id;
    data['user_id'] = user_id;
    data['status'] = status;
    data['valid'] = valid;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    data['montant'] = montant;
    return data;
  }
}
