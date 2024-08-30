import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

import '../../controller/auth/edit_profile_controller.dart';
import '../../layout/profile/change_password_form.dart';
import '../../layout/profile/edit_profile_actions.dart';
import '../../layout/profile/edit_profile_form.dart';
import '../../widget/button.dart';


class ChangePasswordScreen extends GetView<EditProfileController>  {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<EditProfileController>();
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Get.back();
            }
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 50.h),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Text("Warning: After changing your password you will be automatically be logged out by the application!",
              style: theme.typography.titleMedium.copyWith(color: theme.error, fontSize: 17),
              ),
              SizedBox(height: 10,),
              ChangePasswordForm(),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    text: "Change",
                    onPressed: () async {
                      Logger().i("Update password");
                      await controller.changePassword();
                    },
                    options: ButtonOptions(width: 150.w, height: 42.h),
                  ),
                  Button(
                    text: "Cancel",
                    onPressed: () {
                      Logger().i("Cancel update password");
                      Get.back();
                    },
                    options: ButtonOptions(
                        color: theme.secondaryBackground,
                        textStyle:
                        theme.typography.bodyMedium.copyWith(color: theme.primary),
                        borderSide: BorderSide(color: theme.primary, width: 1.5),
                        width: 150.w,
                        height: 42.h,
                        elevation: 0
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
