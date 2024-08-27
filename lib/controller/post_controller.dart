// import 'package:get/get.dart';
// import 'package:logger/logger.dart';
// import 'package:mss_language_learning_app/model/post.dart';
// import 'package:mss_language_learning_app/service/api_service.dart';
// import 'package:mss_language_learning_app/util/api_call_status.dart';
// import 'package:mss_language_learning_app/util/app_constants.dart';
//
// import '../model/api_exceptions.dart';
//
// class PostController extends GetxController {
//   final _listOfPosts = <Post>[].obs;
//
//   List<Post> get getAllPosts => _listOfPosts;
//
//   final apiCallStatus = ApiCallStatus.holding.obs; // api call status
//   final e = ApiException().obs;
//
//   ApiException get getApiException => e.value;
//
//   @override
//   void onInit() {
//     super.onInit();
//     getPostsFromApi();
//   }
//
//   // getting data from api
//   getPostsFromApi() async {
//     // *) perform api call
//     await ApiService.safeApiCall(
//       "${AppConstants.exampleAPI}/posts", // url
//       RequestType.get, // request type (get,post,delete,put)
//       onLoading: () {
//         // *) indicate loading state
//         apiCallStatus.value = ApiCallStatus.loading;
//         update();
//       },
//       onSuccess: (response) {
//         // api done successfully
//         final List<dynamic> postsJson = response.data["posts"];
//         _listOfPosts.addAll(postsJson.map((item) {
//           return Post.fromJson(item);
//         }).toList());
//         // *) indicate success state
//         apiCallStatus.value = ApiCallStatus.success;
//         update();
//       },
//       // if you don't pass this method base client
//       // will automatically handle error and show message to user
//       onError: (error) {
//         e.value = error;
//         Logger().e(
//             "${e.value.statusCode} ${e.value.url} ${e.value.message} ${e.value.response}");
//         // show error message to user
//         // ApiService.handleApiError(error);
//         // *) indicate error status
//         apiCallStatus.value = ApiCallStatus.error;
//         update();
//       },
//     );
//   }
// }
