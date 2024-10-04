import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mekinaye/model/spare_part.dart';
import 'dart:convert';

import '../../model/message.dart';
import '../../model/user.dart';
import '../../service/authorization_service.dart';
import '../../util/app_constants.dart';
import '../../config/config_preference.dart';

class ChatListController extends GetxController {
  var users = <UserModel>[].obs;
  var lastMessages = <Message>[].obs;
  Rx<bool> isLoggedIn = false.obs;
  Rx<bool> isLoading = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;
    isLoggedIn.value = await AuthService.isUserLoggedIn();
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      if (isLoggedIn.value) {
        fetchUsersAndLastMessages();
      } else {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchUsersAndLastMessages() async {
    // final accessToken = ConfigPreference.getAccessToken();

    Map<String, dynamic> userProfile = ConfigPreference.getUserProfile();

    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstants.url}/messages/get-chats?id=${userProfile['id']}'),
        // headers: {
        //   'Authorization': 'Bearer $accessToken',
        // },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(response.body);
        users.value = data.map((item) {
          print(item);
          final userData = item['user'];
          return UserModel(
              id: userData['id'],
              userName: userData['userName'],
              firstName: userData['firstName'],
              lastName: userData['lastName'],
              email: userData['email']);
        }).toList();

        lastMessages.value = data.map((item) {
          final messageData = item['lastMessage'];
          print(messageData);
          return Message(
            id: null,
            sparePartId: messageData['sparePartId'],
            sparePart: SparePart.fromMessageJson(messageData['sparePart']),
            imageUrl: messageData['imageUrl'] != 'null'
                ? '${AppConstants.imageUrl}${messageData['imageUrl']}'
                : '',
            audioUrl: messageData['audioUrl'] != 'null'
                ? '${AppConstants.imageUrl}${messageData['audioUrl']}'
                : '',
            text: messageData['text'],
            senderUsername: messageData['senderUsername'],
            receiverUsername: messageData['receiverUsername'],
            createdAt: DateTime.parse(messageData['createdAt']),
          );
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
    isLoading.value = false;
  }
}
