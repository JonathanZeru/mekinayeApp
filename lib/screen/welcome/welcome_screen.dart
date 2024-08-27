import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/button.dart';

import '../../controller/welcome/welcome_page_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController pageController;
  late WelcomePageController controller;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.put(WelcomePageController());
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      body: Column(
        children: [
        Stack(
              children: [
                Image.asset("assets/images/welcome.png"),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Let's get started",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          Center(
            child: GestureDetector(
              onTap: (){
                ConfigPreference.setFirstLaunchCompleted();
                Get.offAllNamed(AppRoutes.login);
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: theme.primary,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.arrow_forward, size: 50, color: Colors.white,)
              ),
            ),
          )
          // Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //       topRight: Radius.circular(50.r),
          //       topLeft: Radius.circular(50.r),
          //     ),
          //     color: Colors.transparent,
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "Select Language",
          //         style: theme.typography.bodyMedium.copyWith(
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18.sp,
          //         ),
          //       ),
          //       SizedBox(height: 10.h),
          //       // Button(
          //       //   text: "English",
          //       //   onPressed: () {
          //           ConfigPreference.setFirstLaunchCompleted();
          //           Get.offAllNamed(AppRoutes.login);
          //       //   },
          //       //   options: ButtonOptions(
          //       //     width: 150.w,
          //       //     borderRadius: BorderRadius.circular(theme.radius * 3),
          //       //     padding: EdgeInsets.symmetric(vertical: 12.h),
          //       //     color: theme.primary,
          //       //     textStyle: theme.typography.bodyMedium.copyWith(
          //       //       fontWeight: FontWeight.bold,
          //       //       color: theme.primaryBtnText,
          //       //     ),
          //       //   ),
          //       // ),
          //       // SizedBox(height: 10.h),
          //       // Button(
          //       //   text: "Amharic",
          //       //   onPressed: () {
          //       //     ConfigPreference.setFirstLaunchCompleted();
          //       //     Get.offAllNamed(AppRoutes.login);
          //       //   },
          //       //   options: ButtonOptions(
          //       //     width: 150.w,
          //       //     borderRadius: BorderRadius.circular(theme.radius * 3),
          //       //     padding: EdgeInsets.symmetric(vertical: 12.h),
          //       //     color: theme.primary,
          //       //     textStyle: theme.typography.bodyMedium.copyWith(
          //       //       fontWeight: FontWeight.bold,
          //       //       color: theme.primaryBtnText,
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
