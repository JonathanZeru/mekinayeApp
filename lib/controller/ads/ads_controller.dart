import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:mekinaye/util/app_constants.dart';

import '../../model/ads.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class AdsController extends GetxController {
  var adsList = <Ads>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }

  Future<void> fetchAds() async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.url}/advertisement/get-ad'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        adsList.value = (data['data'] as List)
            .map((adJson) => Ads.fromJson(adJson))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch advertisements');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}