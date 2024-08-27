
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetController extends GetxController {

  RxBool hasConnection = true.obs;
  RxBool checkingConnection = true.obs;

  @override
  void onInit() {
    checkConnection();
  }
  Future<void> checkConnection() async {
    checkingConnection.value = true;
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      print("get connection");
      hasConnection.value = true;
    } else {
      hasConnection.value = false;
    }
    checkingConnection.value = false;
  }
}