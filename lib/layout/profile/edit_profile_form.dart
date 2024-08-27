import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/themes/data/app_theme.dart';
import '../../controller/auth/edit_profile_controller.dart';
import '../../util/validator.dart';
import '../../widget/custom_input_field.dart';


class EditProfileForm extends GetView<EditProfileController> {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    return Form(
      key: controller.editProfileFormKey,
      child: Column(
        children: [
          CustomInputField(
            textEditingController: controller.fullNameController,
            hint: "Full Name",
            obscureText: false,
            type: TextInputType.name,
            textStyle: theme.typography.bodySmall,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            validator: (value) {
              return Validator.validateFullName(value);
            },
          ),
          SizedBox(
            height: 5.0.h,
          ),
          CustomInputField(
            textEditingController: controller.emailController,
            hint: "Email",
            obscureText: false,
            type: TextInputType.emailAddress,
            textStyle: theme.typography.bodySmall,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            validator: (value) {
              return Validator.validateEmail(value);
            },
            enabled: false,
          ),
          SizedBox(
            height: 5.0.h,
          ),
          CustomInputField(
            textEditingController: controller.phoneController,
            hint: "Phone Number",
            obscureText: false,
            type: TextInputType.phone,
            textStyle: theme.typography.bodySmall,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            validator: (value) {
              return Validator.validatePhone(value);
            },
            enabled: false,
          )
        ],
      ),
    );
  }
}
