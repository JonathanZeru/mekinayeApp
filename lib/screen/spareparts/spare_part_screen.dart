import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/screen/message/message_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/util/app_constants.dart';

import '../../controller/connection/internet_connection_controller.dart';
import '../../controller/spare_part/spare_part_controller.dart';  // Update import for SparePartController
import '../../generated/assets.dart';
import '../../layout/error/error_screen.dart';
import '../../widget/api_call_widget.dart';
import '../../widget/button.dart';
import '../../widget/leading.dart';
import '../../widget/custom_divider.dart';
import 'package:http/http.dart' as http;
class SparePartScreen extends GetView<SparePartController> {
  const SparePartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final controller = Get.put(SparePartController());
    final internetController = Get.put(InternetController());
    if(internetController.hasConnection.value == false && internetController.checkingConnection.value == false){
      return ErrorScreen(onPress: internetController.checkingConnection);
    }
    return Center(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Ethio Workshop",
              style: theme.typography.titleLarge.copyWith(
                color: theme.primaryText,
                fontSize: 20.0,
              ),
            )
          ),
        body: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
            size: 100,

            ),
            SizedBox(height: 10.h,),
            Text(
              "Under Construction",
              style: theme.typography.titleMedium.copyWith(
                  color: theme.primaryText,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10.h,),Text(
              "This page will be available very soon!",
              style: theme.typography.titleMedium.copyWith(
                  color: theme.primaryText,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),)
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       "Ethio Spare Part",
    //       style: theme.typography.titleLarge.copyWith(
    //         color: theme.primaryText,
    //         fontSize: 20.0,
    //       ),
    //     ),
    //     elevation: 0,
    //     centerTitle: true,
    //   ),
    //   body: Obx(() {
    //     return ApiCallWidget(
    //       status: controller.apiCallStatus.value,
    //       exception: controller.apiException.value,
    //       retry: () => controller.fetchSpareParts(),
    //       child: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
    //           child: GridView.builder(
    //               shrinkWrap: true,
    //               scrollDirection: Axis.vertical,
    //               physics: BouncingScrollPhysics(),
    //               itemCount: controller.spareParts.length,
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 2,
    //                 childAspectRatio: 0.8,
    //               ),
    //               itemBuilder: (context, index) {
    //                 final sparePart = controller.spareParts[index];
    //                 return GestureDetector(
    //                   onTap: () async {
    //                     Get.to(() => MessagingScreen(
    //                         ownerId: sparePart.carBrandId,
    //                         owner: sparePart.carBrand!.owner, args: {
    //                       'isFromNotification': false
    //                     }));
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(12.0),
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                           color: Color(0xFFF5F8FF),
    //                           borderRadius: BorderRadius.all(Radius.circular(20))
    //                       ),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           CachedNetworkImage(
    //                             imageUrl: sparePart.image, // Image URL
    //                             height: 100.h,
    //                             placeholder: (context, url) => Center(child: CircularProgressIndicator()),
    //                             errorWidget: (context, url, error) => Image.asset('assets/images/sparepart.png',height: 100.h,),
    //                           ),
    //                           Text(
    //                             sparePart.name,
    //                             style: theme.typography.titleMedium.copyWith(
    //                                 color: theme.primaryText,
    //                                 fontSize: 15.0,
    //                                 fontWeight: FontWeight.bold
    //                             ),
    //                           ),
    //                           Text(
    //                             sparePart.description,
    //                             style: theme.typography.bodyMedium.copyWith(
    //                               color: theme.primaryText,
    //                               fontSize: 14.0,
    //                             ),
    //                           ),
    //                           SizedBox(height: 8.h),
    //                           Text(
    //                             'Price: \$${sparePart.price.toStringAsFixed(2)}',
    //                             style: theme.typography.bodyMedium.copyWith(
    //                               color: theme.primaryText,
    //                               fontSize: 16.0,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               })
    //
    //
    //       ),
    //     );
    //   }),
    // );
  }
}
