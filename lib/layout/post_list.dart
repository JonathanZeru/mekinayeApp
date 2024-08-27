// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mss_language_learning_app/controller/post_controller.dart';
//
// class PostList extends GetView<PostController> {
//   const PostList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Obx(() => RefreshIndicator(
//             color: Theme.of(context).primaryColor,
//             displacement: 100,
//             onRefresh: () => controller.getPostsFromApi(),
//             child: ListView.separated(
//               physics: const BouncingScrollPhysics(),
//               itemCount: controller.getAllPosts.length,
//               separatorBuilder: (_, __) => const Divider(),
//               itemBuilder: (ctx, index) => ListTile(
//                 title: Text(
//                   controller.getAllPosts[index].title,
//                   maxLines: 1,
//                 ),
//                 subtitle: Text(
//                   controller.getAllPosts[index].body,
//                   maxLines: 2,
//                 ),
//                 leading: CircleAvatar(
//                   radius: 30,
//                   child: Text(
//                     controller.getAllPosts[index].id.toString(),
//                   ),
//                 ),
//               ),
//             ),
//           )),
//     );
//   }
// }
