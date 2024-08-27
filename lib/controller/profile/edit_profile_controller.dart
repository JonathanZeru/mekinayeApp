// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
//
// import 'package:date_picker_plus/date_picker_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart' hide FormData, MultipartFile;
// import 'package:image_picker/image_picker.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:logger/logger.dart';
//
// import 'package:mekinaye/model/api_exceptions.dart';
// import 'package:mekinaye/service/api_service.dart';
// import 'package:mekinaye/service/authorization_service.dart';
// import 'package:mekinaye/util/api_call_status.dart';
// import 'package:mekinaye/util/app_constants.dart';
// import 'package:mekinaye/util/app_routes.dart';
// import 'package:mekinaye/widget/custom_snackbar.dart';
//
// import '../../config/themes/data/app_theme.dart';
//
// class EditProfileController extends GetxController {
//   // Form editing controller
//   final editProfileFormKey = GlobalKey<FormState>();
//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final birthDateController = TextEditingController().obs;
//   final birthDateFocusNode = FocusNode().obs;
//   final country = "Ethiopia".obs;
//   final citizenship = "Ethiopia".obs;
//   late RxInt id = 0.obs;
//
//   // Profile picture controllers
//   final profilePictureString = "".obs;
//   final profilePictureFile = File("").obs;
//   final profilePictureIsFile = false.obs;
//   final profilePictureHasImage = false.obs;
//
//   final apiCallStatus = ApiCallStatus.holding.obs;
//   final e = ApiException().obs;
//   final errorMessage = "".obs;
//
//   ApiException get getApiException => e.value;
//
//   @override
//   Future<void> onInit() async {
//
//   }
//
//   updateProfile() async {
//     if (!editProfileFormKey.currentState!.validate()) {
//       return;
//     }
//     // User user = User(
//     //   firstName: fullNameController.text.split(" ")[0],
//     //   lastName: fullNameController.text.split(" ")[1],
//     //   email: emailController.text,
//     //   phoneNumber: phoneController.text,
//     //   birthDate: birthDateController.value.text,
//     //   country: country.value,
//     //   citizenship: citizenship.value,
//     // );
//     // Map<String, dynamic> userMap = user.toUpdateUserProfileJson(
//     //   id.value,
//     // );
//     // if (profilePictureIsFile.value) {
//     //   userMap["profile_picture"] = await MultipartFile.fromFile(
//     //       profilePictureFile.value.path,
//     //       filename: profilePictureFile.value.path.split('/').last);
//     // }
//     // final formData = FormData.fromMap(userMap);
//     //
//     // final accessToken = await AuthService.getAuthorizationToken();
//     // Map<String, dynamic> header = {
//     //   'Content-Type': 'multipart/form-data',
//     //   "Authorization": "JWT $accessToken"
//     // };
//
//     // await ApiService.safeApiCall(
//     //   "${AppConstants.url}/user/update-profile",
//     //   headers: header,
//     //   RequestType.post,
//     //   data: formData,
//     //   onLoading: () {
//     //     apiCallStatus.value = ApiCallStatus.loading;
//     //     update();
//     //   },
//     //   onSuccess: (response) async {
//     //     var responseData = response.data;
//     //     String? token = responseData['data']['token'];
//     //     apiCallStatus.value = ApiCallStatus.success;
//     //     Logger().i(response.data);
//     //     CustomSnackBar.showCustomToast(
//     //         title: "Success",
//     //         message:
//     //             responseData['message'] ?? "Profile updated successfully!");
//     //     if (token != null) {
//     //       Logger().i("The new token :" + token);
//     //       await AuthService.setAuthorizationToken(token);
//     //     }
//     //     Get.offAllNamed(AppRoutes.initial);
//     //
//     //     update();
//     //   },
//     //   onError: (error) {
//     //     e.value = error;
//     //     apiCallStatus.value = ApiCallStatus.error;
//     //     errorMessage.value = 'Unable to update';
//     //     print(e.value);
//     //     update();
//     //   },
//     // );
//   }
//
//   // @override
//   // void onClose() {
//   //   fullNameController.dispose();
//   //   emailController.dispose();
//   //   phoneController.dispose();
//   //   birthDateController.value.dispose();
//   // }
//
//   Future getImage(bool fromCamera) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(
//         source: fromCamera ? ImageSource.camera : ImageSource.gallery);
//     Logger().i(pickedFile?.path ?? "No image");
//     if (pickedFile != null) {
//       profilePictureFile.value = File(pickedFile.path);
//       Logger().i(profilePictureFile.value.path);
//       profilePictureIsFile.value = true;
//       profilePictureHasImage.value = true;
//
//       await DefaultCacheManager()
//           .putFile(pickedFile.path, profilePictureFile.value.readAsBytesSync());
//     }
//   }
//
//   Future showOptions(BuildContext context) async {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         actions: [
//           CupertinoActionSheetAction(
//             child: const Text('Photo Gallery'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               getImage(false);
//             },
//           ),
//           CupertinoActionSheetAction(
//             child: const Text('Camera'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               getImage(true);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> onTapBirthDate(BuildContext context) async {
//     AppTheme theme = AppTheme.of(context);
//     final date = await showDatePickerDialog(
//       context: context,
//       initialDate: birthDateController.value.text != ""
//           ? DateTime.parse(birthDateController.value.text)
//           : DateTime.now(),
//       minDate: DateTime(1950, 1, 1),
//       maxDate: DateTime.now(),
//       currentDate: DateTime.now(),
//       selectedDate: birthDateController.value.text != ""
//           ? DateTime.parse(birthDateController.value.text)
//           : DateTime.now(),
//       currentDateTextStyle: theme.typography.bodyMedium,
//       daysOfTheWeekTextStyle: theme.typography.bodyMedium,
//       disabledCellsTextStyle: theme.typography.bodyMedium
//           .copyWith(color: theme.primaryText.withOpacity(0.2)),
//       enabledCellsTextStyle: theme.typography.bodyMedium,
//       initialPickerType: PickerType.days,
//       selectedCellTextStyle:
//           theme.typography.bodyMedium.copyWith(color: theme.primaryBtnText),
//       leadingDateTextStyle: theme.typography.bodyMedium,
//       slidersColor: theme.primary,
//       highlightColor: theme.primary.withOpacity(0.1),
//       slidersSize: 20,
//       splashColor: theme.primary.withOpacity(0.3),
//       splashRadius: 40.r,
//       centerLeadingDate: true,
//     );
//     if (date != null) {
//       birthDateController.value.text = date.toString().split(" ")[0];
//     }
//     birthDateFocusNode.value.unfocus();
//   }
// }
