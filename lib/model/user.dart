// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    String message;
    List<User> users;

    Welcome({
        required this.message,
        required this.users,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        message: json["message"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class User {
    int? idUser;
    String? nameUser;
    String? phoneUser;
    String? emailUser;
    String? password;
    String? token;


    User({
       this.idUser,
       this.nameUser,
         this.phoneUser,
         this.emailUser,
         this.password,
         this.token,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["id"],
        nameUser: json["name_user"],
        phoneUser: json["phone_user"],
        emailUser: json["email_user"],
        password: json["password"],
        token: json['token'],

    );

    Map<String, dynamic> toJson() => {
        "id": idUser,
        "name_user": nameUser,
        "phone_user": phoneUser,
        "email_user": emailUser,
        "password": password,

    };
}
