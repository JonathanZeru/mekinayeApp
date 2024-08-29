import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../model/privacy_policy.dart';
import '../../model/terms-and-conditions.dart';
import '../../util/app_constants.dart';

class TermsAndConditionsController extends GetxController {
  var termsAndConditionsList = <TermsAndConditions>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchTermsAndConditions();
    super.onInit();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      // Replace with your API endpoint
      final response = await http.get(Uri.parse('${AppConstants.url}/terms-and-conditions'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        termsAndConditionsList.value = data
            .map((jsonItem) => TermsAndConditions.fromJson(jsonItem))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch terms and conditions');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
