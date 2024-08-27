import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../model/api_exceptions.dart';
import '../../model/spare_part.dart';
import '../../service/api_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';

class SparePartController extends GetxController with SingleGetTickerProviderMixin {
  final _spareParts = <SparePart>[].obs;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  List<SparePart> get spareParts => _spareParts;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void onInit() {
    super.onInit();
    fetchSpareParts();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Animation<double> get animation => _animation;

  void fetchSpareParts() async {
    apiCallStatus.value = ApiCallStatus.loading;

    ApiService.safeApiCall(
      "${AppConstants.url}/spare-parts/get-spareparts",
      RequestType.get,
      onSuccess: (response) {
        final List<dynamic> sparePartsJson = response.data;
        _spareParts.value = sparePartsJson.map((item) {
          return SparePart.fromJson(item);
        }).toList();
        apiCallStatus.value = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
      },
    );
  }

  void fetchSparePartById(int id) async {
    apiCallStatus.value = ApiCallStatus.loading;
    print("id = $id");

    ApiService.safeApiCall(
      "${AppConstants.url}/car-brands/$id/with-spare",
      RequestType.get,
      onSuccess: (response) {
        final sparePartJson = response.data;
        final sparePart = SparePart.fromJson(sparePartJson);
        _spareParts.clear(); // Optional: Clear the list if needed
        _spareParts.add(sparePart);
        apiCallStatus.value = ApiCallStatus.success;
        update();
      },
      onError: (error) {
        apiException.value = error;
        apiCallStatus.value = ApiCallStatus.error;
      },
    );
  }
}
