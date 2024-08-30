import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mekinaye/service/api_service.dart';
import 'package:mekinaye/util/api_call_status.dart';
import 'package:mekinaye/widget/custom_snackbar.dart';

import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/user.dart';
import '../../service/authorization_service.dart';
import '../../util/app_constants.dart';
import '../../util/app_routes.dart';

class EditProfileController extends GetxController {
  // Form editing controller
  final editProfileFormKey = GlobalKey<FormState>();
  // Form editing controller
  final changePasswordFormKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  final birthDateFocusNode = FocusNode().obs;
  late RxInt id = 0.obs;

  final apiCallStatus = ApiCallStatus.holding.obs;
  final e = ApiException().obs;
  final errorMessage = "".obs;

  ApiException get getApiException => e.value;

  @override
  Future<void> onInit() async {
    super.onInit();

    Map<String, dynamic> userProfile = ConfigPreference.getUserProfile();

    id.value = userProfile['id'];
    firstNameController.text = userProfile['firstName'] ?? "";
    lastNameController.text = userProfile['lastName'] ?? "";
    emailController.text = userProfile['email'] ?? "";
    phoneController.text = userProfile['phoneNumber'] ?? "";
    userNameController.text = userProfile['userName'] ?? "";
  }

  updateProfile() async {
    if (!editProfileFormKey.currentState!.validate()) {
      return;
    }

    UserModel user = UserModel(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      userName: userNameController.text,
      phoneNumber: phoneController.text
    );

    Map<String, dynamic> userMap = user.toUpdate();
    var jsonBody = jsonEncode(userMap);

    // final accessToken = ConfigPreference.getAccessToken();
    Map<String, dynamic> header = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer $accessToken"
    };

    await ApiService.safeApiCall(
      "${AppConstants.url}/users/${id.value}/update-user",
      // headers: header,
      RequestType.patch,
      data: jsonBody,
      onLoading: () {
        apiCallStatus.value = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var responseData = response.data;
        apiCallStatus.value = ApiCallStatus.success;
        Logger().i(response.data);

        CustomSnackBar.showCustomToast(
          title: "Success",
          message: responseData['message'] ?? "Profile updated successfully!",
        );

        // Update local storage with new user profile data
        ConfigPreference.storeUserProfile(responseData['data']);
        Get.offAllNamed(AppRoutes.initial);

        update();
      },
      onError: (error) {
        e.value = error;
        apiCallStatus.value = ApiCallStatus.error;
        errorMessage.value = 'Unable to update';
        print(e.value);
        update();
      },
    );
  }
  // Function to delete the account (set status to 0)
  Future<void> deleteAccount() async {
    // final accessToken = ConfigPreference.getAccessToken();
    Map<String, dynamic> header = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer $accessToken"
    };

    Map<String, dynamic> body = {
      'id': id.value,
    };

    try {
      await ApiService.safeApiCall(
        "${AppConstants.url}/users/${id.value}/delete-user",
        // headers: header,
        RequestType.patch,
        data: jsonEncode(body),
        onLoading: () {
          apiCallStatus.value = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) async {
          apiCallStatus.value = ApiCallStatus.success;
          CustomSnackBar.showCustomToast(
            title: "Success",
            message: "Account deleted successfully!",
          );
          update();
        },
        onError: (error) {
          e.value = error;
          apiCallStatus.value = ApiCallStatus.error;
          errorMessage.value = 'Unable to delete account';
          print(e.value);
          update();
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      apiCallStatus.value = ApiCallStatus.error;
    } finally {
      update();
    }
  }
  changePassword() async {
    if (!changePasswordFormKey.currentState!.validate()) {
      return;
    }

    var jsonBody = jsonEncode({
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text
    });

    // final accessToken = ConfigPreference.getAccessToken();
    Map<String, dynamic> header = {
      'Content-Type': 'application/json',
      // "Authorization": "Bearer $accessToken"
    };

    await ApiService.safeApiCall(
      "${AppConstants.url}/users/change-password?id=${id.value}",
      // headers: header,
      RequestType.patch,
      data: jsonBody,
      onLoading: () {
        apiCallStatus.value = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        var responseData = response.data;
        apiCallStatus.value = ApiCallStatus.success;
        Logger().i(response.data);

        CustomSnackBar.showCustomToast(
          title: "Success",
          message: responseData['message'] ?? "Password changed successfully!",
        );

        final userProfile = ConfigPreference.getUserProfile();
        Map<String, dynamic> body = {
          "userId": userProfile['id'],
          "fcmToken": ""
        };

        await ApiService.safeApiCall(
          "${AppConstants.url}/users/update-token",
          RequestType.post,
          data: body,
          onLoading: () {},
          onSuccess: (response) {},
          onError: (error) {},
        );
        AuthService.logout();
        Get.offAllNamed(AppRoutes.login);

        update();
      },
      onError: (error) {
        e.value = error;
        apiCallStatus.value = ApiCallStatus.error;
        errorMessage.value = 'Unable to update';
        print(e.value);
        update();
      },
    );
  }

}
