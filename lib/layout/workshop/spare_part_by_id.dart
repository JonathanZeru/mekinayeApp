import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/model/spare_part.dart';
import 'package:mekinaye/screen/auth/ask_login.dart';
import 'package:mekinaye/screen/auth/login_screen.dart';

import '../../controller/spare_part/spare_part_controller.dart';

import '../../model/user.dart';
import '../../screen/message/message_screen.dart';
import '../../service/authorization_service.dart';
import '../../widget/api_call_widget.dart';
import '../../config/themes/data/app_theme.dart';
import '../../widget/custom_snackbar.dart';

class SingleSparePartScreen extends StatelessWidget {
  final int carBrandId;
  final int ownerId;
  final List<SparePart> spareParts;
  final UserModel owner;
  final String brandName;

  SingleSparePartScreen(
      {required this.carBrandId,
      required this.ownerId,
      required this.spareParts,
      required this.brandName,
      required this.owner});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SparePartController());
    // controller.fetchSparePartById(carBrandId);

    AppTheme theme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          brandName,
          style: theme.typography.titleLarge.copyWith(
            color: theme.primaryText,
            fontSize: 20.0,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: GridView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: spareParts.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final sparePart = spareParts[index];
                return GestureDetector(
                  onTap: () async {
                    print("to messages");
                    bool isLoggedIn = await AuthService.isUserLoggedIn();
                    if (isLoggedIn) {
                      Get.to(() => MessagingScreen(
                          sparePartId: sparePart.id,
                          brandName: brandName,
                          sparePartName: sparePart.name,
                          ownerId: ownerId,
                          owner: owner,
                          args: {'isFromNotification': false}));
                    } else {
                      CustomSnackBar.showCustomSnackBar(
                        title: 'Login',
                        message: 'Please Login or Sign up',
                        duration: Duration(seconds: 2),
                      );
                      Get.to(() => AskToLogin());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 75,
                      width: 70,
                      decoration: BoxDecoration(
                        color: theme.cardBackground,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: sparePart.image, // Image URL
                            height: 100.h,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/logo.png',
                              height: 100.h,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            sparePart.name,
                            textAlign: TextAlign.center,
                            style: theme.typography.titleMedium.copyWith(
                                color: theme.primaryText,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            sparePart.description,
                            style: theme.typography.titleMedium.copyWith(
                              color: theme.primaryText,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Price: ${sparePart.price.toStringAsFixed(2)} ETB',
                            style: theme.typography.titleMedium.copyWith(
                                color: theme.primaryText,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ScaleTransition(
          scale: controller.animation,
          child: FloatingActionButton.extended(
            autofocus: true,
            elevation: 4,
            isExtended: true,
            tooltip: "Chat with provider",
            onPressed: () async {
              bool isLoggedIn = await AuthService.isUserLoggedIn();
              if (isLoggedIn) {
                Get.to(() => MessagingScreen(
                      sparePartId: 0,
                      brandName: brandName,
                      ownerId: ownerId,
                      owner: owner,
                      args: {'isFromNotification': false},
                      sparePartName: '',
                    ));
              } else {
                CustomSnackBar.showCustomSnackBar(
                  title: 'Login',
                  message: 'Please Login or Sign up',
                  duration: Duration(seconds: 2),
                );
                Get.to(() => AskToLogin());
              }
            },
            label: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                  elevation: MaterialStatePropertyAll(0)),
              onPressed: () {
                Get.to(() => MessagingScreen(
                      sparePartId: 0,
                      brandName: brandName,
                      ownerId: ownerId,
                      owner: owner,
                      args: {'isFromNotification': false},
                      sparePartName: '',
                    ));
              },
              icon: const Icon(CupertinoIcons.chat_bubble_fill,
                  color: Colors.white),
              label: Text(
                'Chat with provider',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            backgroundColor: theme.primary,
          ),
        ),
      ),
    );
  }
}
