import 'dart:convert';

import 'user.dart';
import 'property.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Jadwal> jadwal;

  Welcome({
    required this.jadwal,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        jadwal: List<Jadwal>.from(json["jadwal"].map((x) => Jadwal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jadwal": List<dynamic>.from(jadwal.map((x) => x.toJson())),
      };
}

class Jadwal {
  int idJadwal;
  int idPengguna;
  int idProperti;
  String tanggal; 
  String pukul;
  String? pic;
  String? catatan;
  String jadwalDiterima;
  User pengguna;
  Datum properti;

  Jadwal({
    required this.idJadwal,
    required this.idPengguna,
    required this.idProperti,
    required this.tanggal,
    required this.pukul,
    required this.pic,
    required this.catatan,
    required this.jadwalDiterima,
    required this.pengguna,
    required this.properti,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        idJadwal: json["id_jadwal"],
        idPengguna: json["id_pengguna"],
        idProperti: json["id_properti"],
        tanggal: json["tanggal"], // Mengambil tanggal sebagai String dari JSON
        pukul: json["pukul"],
        pic: json["pic"],
        catatan: json["catatan"],
        jadwalDiterima: json["jadwal_diterima"],
        pengguna: User.fromJson(json["pengguna"]),
        properti: Datum.fromJson(json["properti"]),
      );

  Map<String, dynamic> toJson() => {
        "id_jadwal": idJadwal,
        "id_pengguna": idPengguna,
        "id_properti": idProperti,
        "tanggal": tanggal, 
        "pukul": pukul,
        "pic": pic,
        "catatan": catatan,
        "jadwal_diterima": jadwalDiterima,
        "pengguna": pengguna.toJson(),
        "properti": properti.toJson(),
      };
}
