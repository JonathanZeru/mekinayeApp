import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/controller/auth/sign_up_controller.dart';
import 'package:mekinaye/util/validator.dart';
import 'package:mekinaye/widget/custom_input_field.dart';

class SignupForm extends GetView<SignUpController> {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomInputField(
            textEditingController: controller.fullNameController,
            hint: "Full Name",
            obscureText: false,
            type: TextInputType.text,
            textStyle: theme.typography.bodyMedium,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            prefixIcon: Iconify(MaterialSymbols.person_outline,
                size: 20.sp, color: theme.accent5),
            validator: (value) => Validator.validateFullName(value),
          ),
          CustomInputField(
            textEditingController: controller.userNameController,
            hint: "User Name",
            obscureText: false,
            type: TextInputType.text,
            textStyle: theme.typography.bodyMedium,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            prefixIcon: Iconify(MaterialSymbols.person_outline,
                size: 20.sp, color: theme.accent5),
            validator: (value) => Validator.validateWord(value),
          ),
          CustomInputField(
            textEditingController: controller.emailController,
            hint: "Email",
            obscureText: false,
            type: TextInputType.emailAddress,
            textStyle: theme.typography.bodyMedium,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20.sp,
              color: theme.accent5,
            ),
            validator: (value) => Validator.validateEmail(value),
          ),
          CustomInputField(
            textEditingController: controller.phoneController,
            hint: "Phone Number",
            obscureText: false,
            type: TextInputType.phone,
            textStyle: theme.typography.bodyMedium,
            labelTextStyle: theme.typography.labelMedium,
            isDense: true,
            prefixIcon:
                Iconify(Ph.phone_light, size: 20.sp, color: theme.accent5),
            validator: (value) => Validator.validatePhone(value),
          ),
          ValueListenableBuilder(
            valueListenable: controller.obscurePassword,
            builder: (context, value, child) {
              return CustomInputField(
                textEditingController: controller.passwordController,
                hint: "Password",
                obscureText: value,
                passwordInput: true,
                type: TextInputType.text,
                textStyle: theme.typography.bodyMedium,
                labelTextStyle: theme.typography.labelMedium,
                isDense: true,
                validator: (value) => Validator.validatePassword(value),
              );
            },
          ),
        ],
      ),
    );
  }
}
