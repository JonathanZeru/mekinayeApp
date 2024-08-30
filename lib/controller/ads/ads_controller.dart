import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mekinaye/util/app_constants.dart';

import '../../model/ads.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../connection/internet_connection_controller.dart';
class AdsController extends GetxController {
  var adsList = <Ads>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }
  final controller = Get.put(InternetController());
  Future<void> fetchAds() async {
    if(controller.hasConnection.value){
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
}