import 'dart:convert';

import 'user.dart';
import 'property.dart';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  List<Favorite> favorite;

  Welcome({
    required this.favorite,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        favorite: List<Favorite>.from(json["favorite"].map((x) => Favorite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "favorite": List<dynamic>.from(favorite.map((x) => x.toJson())),
      };
}

class Favorite {
  int idFavorite;
  int idPengguna;
  int idProperti;
  User pengguna;
  Datum properti;

  Favorite({
    required this.idFavorite,
    required this.idPengguna,
    required this.idProperti,
    required this.pengguna,
    required this.properti,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        idFavorite: json["id_favorite"],
        idPengguna: json["id_pengguna"],
        idProperti: json["id_properti"],
        pengguna: User.fromJson(json["pengguna"]),
        properti: Datum.fromJson(json["properti"]),
      );

  Map<String, dynamic> toJson() => {
        "id_favorite": idFavorite,
        "id_pengguna": idPengguna,
        "id_properti": idProperti,
        "pengguna": pengguna.toJson(),
        "properti": properti.toJson(),
      };
}
