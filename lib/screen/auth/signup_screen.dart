import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/layout/auth/labeled_header.dart';
import 'package:mekinaye/layout/auth/login/google_auth.dart';
import 'package:mekinaye/layout/auth/router_text.dart';
import 'package:mekinaye/layout/auth/signup/signup_form.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/button.dart';

import '../../controller/auth/sign_up_controller.dart';
import '../../util/api_call_status.dart';
import '../../widget/custom_snackbar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final SignUpController signUpController = Get.put(SignUpController());

    return Scaffold(
        backgroundColor: appTheme.primaryBackground,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabeledHeader(
                  pageLabel: "Create an account",
                ),
                const SignupForm(),
                SizedBox(height: 15.h),
                Obx(() => Button(
                      showLoadingIndicator:
                          signUpController.apiCallStatus.value ==
                              ApiCallStatus.loading,
                      text: "Sign Up",
                      onPressed: () async {
                        if (signUpController.formKey.currentState!.validate()) {
                          await signUpController.signUpUser();
                        }
                      },
                      options: ButtonOptions(
                        width: double.infinity,
                        height: 45.h,
                        padding: EdgeInsets.all(10.h),
                        textStyle: appTheme.typography.titleMedium
                            .copyWith(color: appTheme.primaryBtnText),
                      ),
                    )),
                SizedBox(height: 20.h),
                const RouterText(
                    textOne: "Already have an account?",
                    textTwo: "Login",
                    route: '/login'),
                SizedBox(height: 15.h),
                // const LoginOptions(),
                GoogleAuth(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ));
  }
}
