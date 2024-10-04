import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/gas_station.dart';
import '../../service/api_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';

class GasStationController extends GetxController {
  final _gasStations = <GasStation>[].obs;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  // New list for filtered workshops
  final filteredGasStations = <GasStation>[].obs;

  List<GasStation> get gasStations => _gasStations;
  final commentTitle = TextEditingController();
  final commentDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxInt ratingController = 3.obs;

  // New list for filtered workshops

  RxBool isCreatingLoading = false.obs;
  RxBool isUpdatingLoading = false.obs;
  RxBool isDeletingLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGasStations();
  }

  void fetchGasStations() async {
    apiCallStatus.value = ApiCallStatus.loading;

    ApiService.safeApiCall(
      "${AppConstants.url}/gas-station",
      RequestType.get,
      onSuccess: (response) {
        final List<dynamic> workshopsJson = response.data;
        _gasStations.value = workshopsJson.map((item) {
          return GasStation.fromJson(item);
        }).toList();

        // Initially set the filtered list
        filteredGasStations.assignAll(_gasStations);

        apiCallStatus.value = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
      },
    );
  }

  void filterGasStations(String query) {
    if (query.isEmpty) {
      filteredGasStations.assignAll(_gasStations);
    } else {
      final lowerQuery = query.toLowerCase();
      final results = _gasStations.where((gasStation) {
        return gasStation.city.toLowerCase().contains(lowerQuery) ||
            gasStation.tags.toLowerCase().contains(lowerQuery) ||
            gasStation.subCity.toLowerCase().contains(lowerQuery) ||
            gasStation.uniqueName.toLowerCase().contains(lowerQuery) ||
            gasStation.name.toLowerCase().contains(lowerQuery) ||
            gasStation.description.toLowerCase().contains(lowerQuery);
      }).toList();

      filteredGasStations.assignAll(results);
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
      "${AppConstants.url}/gas-station/rating",
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
        fetchGasStations();
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
    required String title,
    required String description,
    required int rating
  }) async {
    try {
      String accessToken = await ConfigPreference.getAccessToken() ?? '';

      var response = await ApiService.safeApiCall(
        "${AppConstants.url}/gas-station/rating",
        RequestType.put,headers: {
        'Authorization': 'Bearer $accessToken'
      },
        data: {
          'ratingId': ratingId,
          'stars': rating,
          'commentTitle': title,
          'commentDescription': description,
        },
        onSuccess: (response) {
          apiCallStatus.value = ApiCallStatus.success;
          Get.snackbar("Success", "Review updated successfully");

          fetchGasStations();
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
  }) async {
    try {
      String accessToken = await ConfigPreference.getAccessToken() ?? '';


      var response = await ApiService.safeApiCall(
        "${AppConstants.url}/gas-station/rating?ratingId=${ratingId}",
        RequestType.delete,
        headers: {
          'Authorization': 'Bearer $accessToken'
        },
        onSuccess: (response) {
          apiCallStatus.value = ApiCallStatus.success;
          Get.snackbar("Success", "Review deleted successfully");
          fetchGasStations();
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