import 'package:equatable/equatable.dart';

class Contacts extends Equatable {
  final int kisi_id;
  final String kisi_ad;
  final String kisi_tel;
  final String? resim;
  final int? cinsiyet;
  final int city_id;
  final int town_id;
  final String? city_name;
  final String? town_name;

  const Contacts({
    required this.kisi_id,
    required this.kisi_ad,
    required this.kisi_tel,
    this.resim,
    this.cinsiyet,
    required this.city_id,
    required this.town_id,
    required this.city_name,
    required this.town_name,
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      kisi_id: json['kisi_id'],
      kisi_ad: json['kisi_ad'],
      kisi_tel: json['kisi_tel'],
      resim: json['resim'],
      cinsiyet: json['cinsiyet'],
      city_id: json['city_id'],
      town_id: json['town_id'],
      city_name: json['city_name'],
      town_name: json['town_name'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [kisi_id, kisi_ad, city_id];
}
