// ignore_for_file: non_constant_identifier_names

class SearchModel {
  int? localisation;
  int? typebien;
  dynamic nb_piece;
  String? date_debut;
  String? date_fin;

  SearchModel({
    this.localisation,
    this.typebien,
    this.nb_piece,
    this.date_debut,
    this.date_fin,
  });

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      localisation: map['localisation'],
      typebien: map['typebien'],
      nb_piece: map['nb_piece'],
      date_debut: map['date_debut'],
      date_fin: map['date_fin'],
    );
  }

  SearchModel.fromJson(Map<String, dynamic> json) {
    localisation = json['localisation'];
    typebien = json['typebien'];
    nb_piece = json['nb_piece'];
    date_debut = json['date_debut'];
    date_fin = json['date_fin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['localisation'] = localisation;
    data['typebien'] = typebien;
    data['nb_piece'] = nb_piece;
    data['date_debut'] = date_debut;
    data['date_fin'] = date_fin;
    return data;
  }
}
