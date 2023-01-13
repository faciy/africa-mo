class PostMessageResponse {
  String? status;
  int? receptId;

  PostMessageResponse({
    required this.status,
    required this.receptId,
  });

  factory PostMessageResponse.fromMap(Map<String, dynamic> map) {
    return PostMessageResponse(
      status: map['status'],
      receptId: map['recept_id'],
    );
  }

  PostMessageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    receptId = json['recept_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['recept_id'] = receptId;
    return data;
  }
}
