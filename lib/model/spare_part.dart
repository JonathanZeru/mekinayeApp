import '../util/app_constants.dart';
import 'car_brand.dart';

class SparePart {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final int carBrandId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CarBrand? carBrand; // Add carBrand field

  SparePart({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.carBrandId,
    required this.createdAt,
    required this.updatedAt,
     this.carBrand, // Initialize carBrand
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: '${AppConstants.imageUrl}${json['image']}',
      carBrandId: json['carBrandId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      carBrand: CarBrand.fromJson(json['carBrand']), // Parse the carBrand
    );
  }
  factory SparePart.fromWorkshopJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: '${AppConstants.imageUrl}${json['image']}',
      carBrandId: json['carBrandId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'carBrandId': carBrandId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'carBrand': carBrand?.toJson(), // Include carBrand in the JSON output
    };
  }
}