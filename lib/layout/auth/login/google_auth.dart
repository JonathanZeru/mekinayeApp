import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../../../config/themes/data/app_theme.dart';
import '../../../controller/auth/google_sign_in_controller.dart';


class GoogleAuth extends StatefulWidget {
  GoogleAuth({super.key});

  @override
  State<GoogleAuth> createState() => _GoogleAuthState();
}

class _GoogleAuthState extends State<GoogleAuth> {
  String displayName = '';

  String email = '';



  final GoogleSignInController googleSignInController =
  Get.put(GoogleSignInController());
  @override
  Widget build(BuildContext context) {
    AppTheme appTheme = AppTheme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: appTheme.info )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Text("Or" , style: appTheme.typography.bodyMedium.copyWith(color: appTheme.secondaryText),)),
            Expanded(child: Divider(color:  appTheme.info )),
          ],
        ),
        SizedBox(height: 20.h),
        InkWell(
          onTap:()async{
            await googleSignInController.handleGoogleSignIn();
    },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border:
                  Border.all(color: appTheme.accent5, width: 0.5.sp) ,

            ),
            child: Padding(
              padding: EdgeInsets.all(15.r),
              child: SvgPicture.asset('assets/icons/google.svg' , width: 15.w, height: 30.h, fit: BoxFit.contain,)
            ),
          ),
        )
      ],
    );
  }
}
