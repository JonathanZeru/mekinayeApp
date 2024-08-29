import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/privacy_policy.dart';
import 'package:mekinaye/util/app_constants.dart';

class PrivacyPolicyController extends GetxController {
  var privacyPolicies = <PrivacyPolicy>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPrivacyPolicies();
    super.onInit();
  }

  Future<void> fetchPrivacyPolicies() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.url}/privacy-policy'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        privacyPolicies.value = data.map((json) => PrivacyPolicy.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch privacy policies');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
