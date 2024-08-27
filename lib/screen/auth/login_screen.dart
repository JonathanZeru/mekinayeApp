import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/controller/auth/login_controller.dart';
import 'package:mekinaye/layout/auth/labeled_header.dart';
import 'package:mekinaye/layout/auth/login/login_form.dart';
import 'package:mekinaye/layout/auth/login/google_auth.dart';
import 'package:mekinaye/layout/auth/login/login_options.dart';
import 'package:mekinaye/layout/auth/router_text.dart';
import 'package:mekinaye/util/api_call_status.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/button.dart';
import 'package:mekinaye/widget/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginPageController loginController = Get.put(LoginPageController());
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.primaryBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Column(
                children: [
                  const LabeledHeader(
                    pageLabel: "Welcome Back",
                  ),
                  const LoginForm(),
                  SizedBox(height: 5.h),
                  Obx(() {
                    final errorMessage = loginController.errorMessage.value;
                    return errorMessage.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(errorMessage,
                                style: appTheme.typography.bodyMedium.copyWith(
                                    color: appTheme.error,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold)),
                          )
                        : const SizedBox.shrink();
                  }),
                  Button(
                    showLoadingIndicator: loginController.apiCallStatus.value == ApiCallStatus.loading,
                    text: "Log in",
                    onPressed: () async {
                      loginController.errorMessage.value = '';
                      if (loginController.formKey.currentState?.validate() ??
                          false) {
                        loginController.formKey.currentState?.save();
                        await loginController.loginUser();
                      }
                    },
                    options: ButtonOptions(
                      width: double.infinity,
                      height: 45.h,
                      padding: EdgeInsets.all(10.h),
                      textStyle: appTheme.typography.titleMedium
                          .copyWith(color: appTheme.primaryBtnText),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  const LoginOptions(),
                  GoogleAuth(),
                  SizedBox(height: 20.h),
                  const RouterText(
                    textOne: "Don't have an account?",
                    textTwo: "Sign up",
                    route: '/signup',
                  ),
                  Button(
                    showLoadingIndicator: loginController.apiCallStatus.value == ApiCallStatus.loading,
                    text: "Guest Sign in",
                    onPressed: () async {
                      Get.offAllNamed(AppRoutes.initial);
                    },
                    options: ButtonOptions(
                      width: double.infinity,
                      height: 45.h,
                      padding: EdgeInsets.all(10.h),
                      textStyle: appTheme.typography.titleMedium
                          .copyWith(color: appTheme.primaryBtnText),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(() {
            if (loginController.apiCallStatus.value == ApiCallStatus.loading) {
              return Container(
                color: appTheme.primary.withOpacity(0.1),
                child: Center(
                  child: SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: CircularProgressIndicator(
                      color: appTheme.primary,
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }
}
