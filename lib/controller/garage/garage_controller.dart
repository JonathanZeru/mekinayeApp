import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/garage.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';

class WorkshopsController extends GetxController {
  final _workshops = <Workshop>[].obs;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;
  final commentTitle = TextEditingController();
  final commentDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxInt ratingController = 3.obs;

  // New list for filtered workshops
  final filteredWorkshops = <Workshop>[].obs;

  List<Workshop> get workshops => _workshops;
  RxBool isCreatingLoading = false.obs;
  RxBool isUpdatingLoading = false.obs;
  RxBool isDeletingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkshops();
  }

  void fetchWorkshops() async {
    apiCallStatus.value = ApiCallStatus.loading;

    ApiService.safeApiCall(
      "${AppConstants.url}/workshop",
      RequestType.get,
      onSuccess: (response) {
        final List<dynamic> workshopsJson = response.data;
        _workshops.value = workshopsJson.map((item) {
          return Workshop.fromJson(item);
        }).toList();

        filteredWorkshops.assignAll(_workshops);

        apiCallStatus.value = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
      },
    );
  }

  // New method to filter the workshops based on user's input
  void filterWorkshops(String query) {
    if (query.isEmpty) {
      filteredWorkshops.assignAll(_workshops);
    } else {
      final lowerQuery = query.toLowerCase();
      final results = _workshops.where((workshop) {
        return workshop.city.toLowerCase().contains(lowerQuery) ||
            workshop.tags.toLowerCase().contains(lowerQuery) ||
            workshop.subCity.toLowerCase().contains(lowerQuery) ||
            workshop.uniqueName.toLowerCase().contains(lowerQuery) ||
            workshop.name.toLowerCase().contains(lowerQuery) ||
            workshop.description.toLowerCase().contains(lowerQuery);
      }).toList();

      filteredWorkshops.assignAll(results);
    }
  }
  void submitRatingAndComment(int workshopId) async {
    isCreatingLoading.value = true;
    String accessToken = await ConfigPreference.getAccessToken() ?? '';


    final body = {
      "stars": ratingController.value,
      "commentTitle": commentTitle.text,
      "commentDescription": commentDescription.text,
      "workshopId": workshopId,
    };
    print(body);

    apiCallStatus.value = ApiCallStatus.loading;

    ApiService.safeApiCall(
      "${AppConstants.url}/workshop/rating",
      headers: {
        'Authorization': 'Bearer $accessToken'
      },
      RequestType.post,
      data: body,
      onSuccess: (response) {
        isCreatingLoading.value = false;
        apiCallStatus.value = ApiCallStatus.success;
        Get.snackbar("Success", "Review submitted successfully");
        commentTitle.text = "";
        commentDescription.text = "";
        ratingController.value = 3;
        print(response);
        fetchWorkshops();
      },
      onError: (error) {
        isCreatingLoading.value = false;
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
        Get.snackbar("Error", "Failed to submit review: ${error.message}");
      },
    );
    isCreatingLoading.value = false;
  }
  Future<void> updateRating({
    required int ratingId,
    required int workshopId,
    required String title,
    required String description,
    required int rating
  }) async {
    try {
      String accessToken = await ConfigPreference.getAccessToken() ?? '';

      var response = await ApiService.safeApiCall(
        "${AppConstants.url}/workshop/rating",
        RequestType.put,headers: {
        'Authorization': 'Bearer $accessToken'
      },
        data: {
          'ratingId': ratingId,
          'stars': rating,
          'commentTitle': title,
          'commentDescription': description,
          'workshopId': workshopId,
        },
        onSuccess: (response) {
          apiCallStatus.value = ApiCallStatus.success;
          Get.snackbar("Success", "Review updated successfully");

          fetchWorkshops();
          // You can perform additional actions like clearing the form or updating the UI
        },
        onError: (error) {
          apiException.value = error;
          apiCallStatus.value = ApiCallStatus.error;
          Get.snackbar("Error", "Failed to updated review: ${error.message}");
        },
      );

    } catch (e) {
      isUpdatingLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  // Method to delete a rating
  void deleteRating({
    required int ratingId,
    required int workshopId,
  }) async {
    try {
      String accessToken = await ConfigPreference.getAccessToken() ?? '';


      var response = await ApiService.safeApiCall(
        "${AppConstants.url}/workshop/rating?ratingId=${ratingId}&workshopId=${workshopId}",
        RequestType.delete,
        headers: {
          'Authorization': 'Bearer $accessToken'
        },
        onSuccess: (response) {
          apiCallStatus.value = ApiCallStatus.success;
          Get.snackbar("Success", "Review deleted successfully");
          fetchWorkshops();
          // You can perform additional actions like clearing the form or updating the UI
        },
        onError: (error) {
          apiException.value = error;
          apiCallStatus.value = ApiCallStatus.error;
          Get.snackbar("Error", "Failed to deleted review: ${error.message}");
        },
      );

    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}