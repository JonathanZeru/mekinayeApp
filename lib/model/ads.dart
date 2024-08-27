
import 'package:mekinaye/util/app_constants.dart';

class Ads {
  final int id;
  final String name;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  Ads({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an Ads object from JSON
  factory Ads.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if(json['image']!=null){
      imageUrl = '${AppConstants.imageUrl}${json['image']}';
    }
    return Ads(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: imageUrl,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}