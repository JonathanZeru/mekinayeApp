import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/controller/auth/login_controller.dart';
import 'package:mekinaye/util/api_call_status.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/util/validator.dart';
import 'package:mekinaye/widget/custom_input_field.dart';

class LoginForm extends GetView<LoginPageController> {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomInputField(
            textEditingController: controller.userNameController,
            hint: "Username",
            obscureText: false,
            type: TextInputType.emailAddress,
            isDense: true,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20.sp,
              color: theme.primaryText.withOpacity(0.50),
            ),
            validator: (value) => Validator.validateWord(value),
          ),
          SizedBox(
            height: 8.h,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.obscurePassword,
            builder: (context, value, child) {
              return CustomInputField(
                textEditingController: controller.passwordController,
                hint: "Password",
                obscureText: value,
                passwordInput: true,
                type: TextInputType.text,
                validator: (value) => Validator.validatePassword(value),
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) async {
                  if (controller.formKey.currentState?.validate() ?? false) {
                    controller.formKey.currentState?.save();
                    await controller.loginUser();
                    if (controller.apiCallStatus.value ==
                        ApiCallStatus.success) {
                      Get.offAllNamed(AppRoutes.initial);
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
