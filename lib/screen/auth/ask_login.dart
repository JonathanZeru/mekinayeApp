import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

import '../../widget/button.dart';
import 'login_screen.dart';

class AskToLogin extends StatelessWidget {
  const AskToLogin({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Get.back();
          },
        ),
        title: Text('Login in'),
      ),
      body: Center(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            "Login or Sign up",
            style: theme.typography.titleMedium.copyWith(
                color: theme.primaryText,
                fontSize: 20.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.h,),Text(
            "to see the spare parts available.",
            style: theme.typography.titleMedium.copyWith(
                color: theme.primaryText,
                fontSize: 15.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 10.h,),
          Button(
            text: "Login in",
            onPressed: () async {
              Get.to(() => LoginScreen());
            },
            options: ButtonOptions(
              width: double.infinity,
              height: 45.h,
              padding: EdgeInsets.all(10.h),
              textStyle: theme.typography.titleMedium
                  .copyWith(color: theme.primaryBtnText),
            ),
          )

        ],
      )),
    ));
  }
}
