class Town {
  int townId;
  int cityId;
  String townName;

  Town({required this.townId, required this.cityId, required this.townName});

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      townId: json['town_id'],
      cityId: json['city_id'],
      townName: json['town_name'],
    );
  }
}
