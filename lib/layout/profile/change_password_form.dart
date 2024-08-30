import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/themes/data/app_theme.dart';
import '../../controller/auth/edit_profile_controller.dart';
import '../../util/validator.dart';
import '../../widget/custom_input_field.dart';

class ChangePasswordForm extends GetView<EditProfileController> {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    return Form(
      key: controller.changePasswordFormKey,
      child: Column(
        children: [
          CustomInputField(
            label: 'Old Password',
            textEditingController: controller.oldPasswordController,
            hint: "Old Password",
            obscureText: false,
            type: TextInputType.name,
            textStyle: theme.typography.bodySmall,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            validator: (value) {
              return Validator.validateWord(value);
            },
          ),
          SizedBox(
              height: 5.0.h
          ),
          CustomInputField(
            label: 'New Password',
            textEditingController: controller.newPasswordController,
            hint: "New Password",
            obscureText: false,
            type: TextInputType.name,
            textStyle: theme.typography.bodySmall,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            validator: (value) {
              return Validator.validateWord(value);
            },
          ),
        ],
      ),
    );
  }
}
