import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/user.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../service/firebase_Service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';
import '../../util/app_routes.dart';
import '../../widget/custom_snackbar.dart';
import '../firebase/fcm_token_controller.dart';

class GoogleSignInController extends GetxController {
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;
  final e = ApiException().obs;
  ApiException get getApiException => e.value;
  final RxString errorMessage = "".obs;
  final _fcmTokenController = Get.put(FcmTokenController());

  final FirebaseService _firebaseService =
      FirebaseService(); // Initialize FirebaseService

  Future<void> handleGoogleSignIn() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: <String>[
          'openid',
          'email',
          'profile',
        ],
      );

      // Trigger the authentication flow
      var googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        List<String>? nameParts = googleUser.displayName?.split(' ');
        String firstName = nameParts![0];
        String lastName =
            nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        UserModel userJson = UserModel(
          firstName: firstName,
          lastName: lastName,
          email: googleUser.email,
          type: "buyer",
        );

        String fcmToken = await _firebaseService.getFCMToken();

        // Prepare request body
        var requestBody = userJson.toGoogleSignInUpdate();
        requestBody['fcmToken'] = fcmToken;

        var jsonBody = jsonEncode(requestBody);

        await ApiService.safeApiCall(
          "${AppConstants.url}/users/google-sign-in",
          RequestType.post,
          data: jsonBody,
          onLoading: () {
            apiCallStatus.value = ApiCallStatus.loading;
            update();
          },
          onSuccess: (response) async {
            var responseData = response.data;
            if (responseData['message'] == "Authentication successful") {
              String token = responseData['token'];
              await AuthService.setAuthorizationToken(token);
              await ConfigPreference.storeUserGoogleProfile(
                  responseData['user']);
              _fcmTokenController.registerFCMToken(responseData['user']['id']);
              await ConfigPreference.storeAccessToken(token);

              apiCallStatus.value = ApiCallStatus.success;
              CustomSnackBar.showCustomSnackBar(
                title: 'Success',
                message: 'Authentication Successful',
                duration: Duration(seconds: 2),
              );
              Get.offAllNamed(AppRoutes.initial);
            } else {
              String token = responseData['accessToken'];
              await AuthService.setAuthorizationToken(token);
              await ConfigPreference.storeUserGoogleProfile(
                  responseData['data']);
              _fcmTokenController.registerFCMToken(responseData['data']['id']);
              await ConfigPreference.storeAccessToken(token);

              apiCallStatus.value = ApiCallStatus.success;
              CustomSnackBar.showCustomSnackBar(
                title: 'Success',
                message: 'Login Successful',
                duration: Duration(seconds: 2),
              );
              Get.offAllNamed(AppRoutes.initial);
            }

            update();
          },
          onError: (error) {
            apiCallStatus.value = ApiCallStatus.error;
            CustomSnackBar.showCustomErrorToast(
              title: 'Error',
              message: 'Login Error',
              duration: Duration(seconds: 2),
            );
            update();
          },
        );
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
}
