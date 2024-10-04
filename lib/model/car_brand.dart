import 'package:mekinaye/model/spare_part.dart';
import 'package:mekinaye/model/user.dart';

import '../util/app_constants.dart';

class CarBrand {
  final int? id;
  final String? name;
  final String? description;
  final String? phoneNumber;
  final String? image;
  final int? ownerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<SparePart>? spareParts;
  final UserModel? owner; // Add the owner field

  CarBrand({
    this.id,
    this.name,
    this.description,
    this.phoneNumber,
    this.image,
    this.ownerId,
    this.createdAt,
    this.updatedAt,
    this.spareParts,
    this.owner, // Initialize the owner
  });

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    String image = '${AppConstants.imageUrl}${json['image']}';
    return CarBrand(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      image: image,
      ownerId: json['ownerId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      spareParts: json['spareParts'] != null
          ? (json['spareParts'] as List)
          .map((item) => SparePart.fromWorkshopJson(item))
          .toList()
          : [], // Handle null or empty spareParts list
      owner: UserModel.fromWorkShopJson(json['owner']), // Parse the owner from JSON
    );
  }
  factory CarBrand.fromMessageJson(Map<String, dynamic> json) {
    print(json);
    String image = '${AppConstants.imageUrl}${json['image']}';
    return CarBrand(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      phoneNumber: json['phoneNumber'],
      image: image,
      ownerId: json['ownerId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'phoneNumber': phoneNumber,
      'image': image,
      'ownerId': ownerId,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
      'spareParts': spareParts?.map((sp) => sp.toJson()).toList(),
      'owner': owner!.toJson(), // Include the owner in the JSON output
    };
  }
}
