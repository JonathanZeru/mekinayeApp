import 'package:mekinaye/model/user.dart';

import '../../util/app_constants.dart';


class GasStation {
  int id;
  String name;
  String description;
  String? image;
  String wereda;
  String kebele;
  String city;
  double overAllRating;
  String subCity;
  String uniqueName;
  String longitude;
  String latitude;
  String mapUrl;
  String tags;
  DateTime createdAt;
  DateTime updatedAt;
  List<Email> emails;
  List<Phone> phones;
  List<Rating> ratings;

  GasStation({
    required this.id,
    required this.name,
    required this.description,
    this.image,
    required this.wereda,
    required this.kebele,
    required this.city,
    required this.overAllRating,
    required this.subCity,
    required this.uniqueName,
    required this.longitude,
    required this.latitude,
    required this.mapUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.emails,
    required this.phones,
    required this.ratings,
  });

  factory GasStation.fromJson(Map<String, dynamic> json) {
    return GasStation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: '${AppConstants.imageUrl}${json['image']}',
      wereda: json['wereda'],
      kebele: json['kebele'],
      city: json['city'],
      overAllRating: json['overAllRating'].toDouble(),
      subCity: json['subCity'],
      uniqueName: json['uniqueName'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      mapUrl: json['mapUrl'] ?? '',
      tags: json['tags'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      emails: (json['emails'] as List).map((e) => Email.fromJson(e)).toList(),
      phones: (json['phones'] as List).map((p) => Phone.fromJson(p)).toList(),
      ratings: (json['ratings'] as List).map((r) => Rating.fromJson(r)).toList(),
    );
  }
}

class Email {
  int id;
  String emailAddress;
  int workshopId;
  int? gasStationId;

  Email({
    required this.id,
    required this.emailAddress,
    required this.workshopId,
    this.gasStationId,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id'],
      emailAddress: json['emailAddress'],
      workshopId: json['workshopId'] ?? 0,
      gasStationId: json['gasStationId'] ?? 0
    );
  }
}

class Phone {
  int id;
  String phoneNumber;
  int workshopId;
  int? gasStationId;

  Phone({
    required this.id,
    required this.phoneNumber,
    required this.workshopId,
    this.gasStationId,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id'],
      phoneNumber: json['phoneNumber'],
      workshopId: json['workshopId'] ?? 0,
      gasStationId: json['gasStationId'] ?? 0
    );
  }
}

class Rating {
  int id;
  int stars;
  String commentTitle;
  String commentDescription;
  int? gasStationId;
  int userId;
  UserModel user;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Rating({
    required this.id,
    required this.stars,
    required this.commentTitle,
    required this.commentDescription,
    this.gasStationId,
    required this.userId,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      stars: json['stars'],
      commentTitle: json['commentTitle'],
      commentDescription: json['commentDescription'],
      gasStationId: json['gasStationId'] ?? 0,
      userId: json['userId'],
      user: UserModel.fromJson(json['user']),
      createdAt:
      DateTime.parse(json['createdAt']),
      updatedAt:
      DateTime.parse(json['updatedAt']),
    );
  }
}
