import 'dart:convert';

import 'package:flutter/src/painting/box_fit.dart';

Property propertyFromJson(String str) => Property.fromJson(json.decode(str));

String propertyToJson(Property data) => json.encode(data.toJson());

class Property {
    bool status;
    String message;
    List<Datum> data;

    Property({
        required this.status,
        required this.message,
        required this.data,
    });

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final int id;
    final String name;
    final String price;
    final String status;
    final String address;
    final double latitude;
    final double longitude;
    final String description;
    final int sqft;
    final int bath;
    final int garage;
    final int floor;
    final int bed;
    final DateTime createdAt;
    final DateTime updatedAt;
    final List<Image> images;

    Datum({
        required this.id,
        required this.name,
        required this.price,
        required this.status,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.description,
        required this.sqft,
        required this.bath,
        required this.garage,
        required this.floor,
        required this.bed,
        required this.createdAt,
        required this.updatedAt,
        required this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        status: json["status"],
        address: json["address"],
        latitude: json['koordinat']['coordinates'][1],
        longitude: json['koordinat']['coordinates'][0],
        description: json["description"],
        sqft: json["sqft"],
        bath: json["bath"],
        garage: json["garage"],
        floor: json["floor"],
        bed: json["bed"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    );

  get idPengguna => null;

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "status": status,
        "address": address,
        "latitude": latitude,
        "longitude" : longitude,
        "description": description,
        "sqft": sqft,
        "bath": bath,
        "garage": garage,
        "floor": floor,
        "bed": bed,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
}

class Image {
    int id;
    int propertyId;
    String image;
    DateTime createdAt;
    DateTime updatedAt;

    Image({
        required this.id,
        required this.propertyId,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        propertyId: json["property_id"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "property_id": propertyId,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };

  static network(String s, {required BoxFit fit}) {}
}

class Koordinat {
    String type;
    List<double> coordinates;

    Koordinat({
        required this.type,
        required this.coordinates,
    });

    factory Koordinat.fromJson(Map<String, dynamic> json) => Koordinat(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}
