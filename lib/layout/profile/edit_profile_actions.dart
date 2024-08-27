import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../config/themes/data/app_theme.dart';
import '../../controller/auth/edit_profile_controller.dart';
import '../../widget/button.dart';

class EditProfileActions extends GetView<EditProfileController> {
  const EditProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Button(
          text: "Update",
          onPressed: () async {
            Logger().i("Update profile");
            await controller.updateProfile();
          },
          options: ButtonOptions(width: 150.w, height: 42.h),
        ),
        Button(
          text: "Cancel",
          onPressed: () {
            Logger().i("Cancel update Profile");
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
    );
  }
}
