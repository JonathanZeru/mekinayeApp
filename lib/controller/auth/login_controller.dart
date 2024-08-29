import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/user.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';
import '../../util/app_routes.dart';
import '../../widget/custom_snackbar.dart';
import '../firebase/fcm_token_controller.dart';


class LoginPageController extends GetxController {

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(false);
  final apiCallStatus = ApiCallStatus.holding.obs;
  final RxBool isLoading = false.obs;
  final apiException = ApiException().obs;
  final e = ApiException().obs;
  ApiException get getApiException => e.value;
  final RxString errorMessage = "".obs;
  final _fcmTokenController = Get.put(FcmTokenController());

  Future<void> loginUser() async {
    isLoading.value = true;
    UserModel user = UserModel(
      password: passwordController.text,
      userName: userNameController.text
    );


    var request = user.toUserJson();
    var jsonBody = jsonEncode(request);
    print(jsonBody);
    await ApiService.safeApiCall(
      "${AppConstants.url}/users/login",
      RequestType.post,
      data: jsonBody,
      onLoading: () {
        isLoading.value = true;
        apiCallStatus.value = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) async {
        //here
        var responseData = response.data;
        String token = responseData['accessToken'];
        await AuthService.setAuthorizationToken(token);
        await ConfigPreference.storeUserProfile(responseData['data']);
        _fcmTokenController.registerFCMToken(responseData['data']['id']);
        await ConfigPreference.storeAccessToken(responseData['accessToken']);

        final accessToken = await AuthService.getAuthorizationToken();

        apiCallStatus.value = ApiCallStatus.success;
        CustomSnackBar.showCustomSnackBar(
          title: 'Success',
          message: 'Login Successful',
          duration: Duration(seconds: 2),
        );
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.initial);
        update();
      },
      onError: (error) {
        isLoading.value = false;
        apiCallStatus.value = ApiCallStatus.error;
        isLoading.value = false;
        CustomSnackBar.showCustomErrorToast(
          title: 'Error',
          message: 'Login Error',
          duration: Duration(seconds: 2),
        );
        isLoading.value = false;
        update();
      },
    );
    isLoading.value = false;
  }

}