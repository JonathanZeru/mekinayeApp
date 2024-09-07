import 'package:mekinaye/model/spare_part.dart';

class UserModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final int? status;
  final String? userName;
  final String? phoneNumber;
  final String? type;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.status,
      this.userName,
      this.phoneNumber,
      this.type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
        status: json['status'],
        userName: json['userName'],
        phoneNumber: json['phoneNumber'],
        type: json['type']);
  }
  factory UserModel.fromWorkShopJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        userName: json['userName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'status': status,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'type': type,
    };
  }

  Map<String, dynamic> toUserJson() {
    return {'password': password, 'userName': userName};
  }

  Map<String, dynamic> toUpdate() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'type': "buyer",
      'userName': userName,
      'phoneNumber': phoneNumber
    };
  }

  Map<String, dynamic> toGoogleSignInUpdate() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'type': "buyer",
    };
  }
}
