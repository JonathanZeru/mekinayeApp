import 'package:get/get.dart';

import '../../model/api_exceptions.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../service/firebase_Service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';

class FcmTokenController extends GetxController {
  final _firebaseService = FirebaseService();

  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  void registerFCMToken(int userId) async {
    final fcmToken = await _firebaseService.getFCMToken();
    Map<String, dynamic> body = {
      "userId": userId,
      "fcmToken": fcmToken
    };

    await ApiService.safeApiCall(
      "${AppConstants.url}/users/update-token",
      RequestType.post,
      data: body,
      onLoading: () {
        apiCallStatus.value = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        apiCallStatus.value = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
        update();
      },
    );
  }
}
