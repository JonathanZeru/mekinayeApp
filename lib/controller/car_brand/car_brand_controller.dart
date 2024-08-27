import 'package:get/get.dart';


import '../../model/api_exceptions.dart';
import '../../model/car_brand.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../util/api_call_status.dart';
import '../../util/app_constants.dart';  // Update with the correct path to your model

class CarBrandsController extends GetxController {
  final _carBrands = <CarBrand>[].obs;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  List<CarBrand> get carBrands => _carBrands;

  @override
  void onInit() {
    super.onInit();
    fetchCarBrands();
  }

  void fetchCarBrands() async {

    apiCallStatus.value = ApiCallStatus.loading;

    ApiService.safeApiCall(
      "${AppConstants.url}/car-brands/all-car-brands-with-spares",  // Update with the correct endpoint
      RequestType.get,
      // headers: ,
      onSuccess: (response) {
        final List<dynamic> carBrandsJson = response.data;
        _carBrands.value = carBrandsJson.map((item) {
          return CarBrand.fromJson(item);
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
}
