class User {
  String? email;
  String? sifre;
  int? id;

  User({this.email, this.sifre, this.id});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    sifre = json['sifre'];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['sifre'] = this.sifre;
    data["id"] = this.id;
    return data;
  }
}
