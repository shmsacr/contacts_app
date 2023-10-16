class City {
  int city_id;
  String city_name;

  City({required this.city_id, required this.city_name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      city_id: json['city_id'],
      city_name: json['city_name'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.city_id;
    data['city_name'] = this.city_name;
    return data;
  }
}
