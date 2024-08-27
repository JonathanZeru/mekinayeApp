import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/data/app_theme.dart';
import '../../widget/button.dart';

class ErrorScreen extends StatelessWidget {
  Function() onPress;
  ErrorScreen({super.key,
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {

    AppTheme theme = AppTheme.of(context);
    return SafeArea(
      child: Scaffold(
          body: Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi, size: 100),
              Text(
                "Error Connection",
                style: theme.typography.titleMedium.copyWith(
                    color: theme.primaryText,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.h,),
              Text(
                "Please connect to the internet.",
                style: theme.typography.titleMedium.copyWith(
                    color: theme.primaryText,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10.h,),
              Button(
                text: "Refresh",
                onPressed: onPress,
                options: ButtonOptions(
                  width: double.infinity,
                  height: 45.h,
                  padding: EdgeInsets.all(10.h),
                  textStyle: theme.typography.titleMedium
                      .copyWith(color: theme.primaryBtnText),
                ),
              )

            ],
          ))
      ),
    );
  }
}
