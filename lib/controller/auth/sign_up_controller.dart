import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/api_exceptions.dart';
import '../../model/user.dart'; // Make sure to import your User model here
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../service/firebase_service.dart'; // Import FirebaseService
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';
import '../../util/app_routes.dart';
import '../../widget/custom_snackbar.dart'; // Ensure this import path is correct

class SignUpController extends GetxController {

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(false);
  final TextEditingController verificationCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  bool verified = false;
  RxBool isTermsAndPrivacyAccepted = false.obs;
  bool verificationCodeReceived = false;

  final FirebaseService _firebaseService = FirebaseService(); // Initialize FirebaseService

  Future<void> signUpUser() async {
    List<String> nameParts = fullNameController.text.split(' ');
    String firstName = nameParts[0];
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    UserModel user = UserModel(
        firstName: firstName,
        lastName: lastName,
        email: emailController.text,
        password: passwordController.text,
        status: 1,
        userName: userNameController.text,
        phoneNumber: phoneController.text,
        type: "buyer"
    );

    try {
      // Fetch FCM token
      String fcmToken = await _firebaseService.getFCMToken();

      // Add FCM token to the user object
      var requestBody = user.toJson();
      requestBody['fcmToken'] = fcmToken;

      var jsonBody = jsonEncode(requestBody);

      await ApiService.safeApiCall(
        "${AppConstants.url}/users/register",
        RequestType.post,
        data: jsonBody,
        onLoading: () {
          apiCallStatus.value = ApiCallStatus.loading;
          update();
        },
        onSuccess: (response) async {
          var responseData = response.data;

          apiCallStatus.value = ApiCallStatus.success;
          CustomSnackBar.showCustomSnackBar(
            title: 'Success',
            message: 'Registration Successful',
            duration: Duration(seconds: 2),
          );
          Get.offAndToNamed(AppRoutes.login);
          update();
        },
        onError: (error) {
          ApiService.handleApiError(error);
          apiException.value = error;
          apiCallStatus.value = ApiCallStatus.error;
          CustomSnackBar.showCustomErrorToast(
            title: 'Error',
            message: 'Registration Error',
            duration: Duration(seconds: 2),
          );
          update();
        },
      );
    } catch (e) {
      Logger().e("Error during sign up: $e");
      CustomSnackBar.showCustomErrorToast(
        title: 'Error',
        message: 'Failed to register. Please try again.',
        duration: Duration(seconds: 2),
      );
    }
  }

}
