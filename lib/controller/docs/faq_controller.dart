import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/faq.dart';
import '../../util/app_constants.dart';

class FAQController extends GetxController {
  var faqList = <FAQ>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFAQ();
    super.onInit();
  }

  Future<void> fetchFAQ() async {
    try {
      // Replace with your API endpoint
      final response = await http.get(Uri.parse('${AppConstants.url}/faq'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        faqList.value = data
            .map((jsonItem) => FAQ.fromJson(jsonItem))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch FAQ');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
