import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/controller/auth/login_controller.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/custom_checkbox.dart';

class LoginOptions extends StatelessWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginPageController loginController = Get.find();
    final AppTheme theme = AppTheme.of(context);

    return SizedBox(
      height: 30.h,
      width: 340.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              // Get.toNamed(AppRoutes.insertEmail);
            },
            child: Text(
              'Forgot Password ?',
              style: theme.typography.bodySmall.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
