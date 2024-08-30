
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../model/rules.dart';
import 'package:http/http.dart' as http;

import '../../util/app_constants.dart';
class RulesController extends GetxController {
  var faqList = <Rules>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchRules();
    super.onInit();
  }

  Future<void> fetchRules() async {
    try {
      // Replace with your API endpoint
      final response = await http.get(Uri.parse('${AppConstants.url}/rules'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        faqList.value = data
            .map((jsonItem) => Rules.fromJson(jsonItem))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch rules');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}