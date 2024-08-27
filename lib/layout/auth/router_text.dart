import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

class RouterText extends StatelessWidget {
  final String textOne;
  final String textTwo;
  final String route;

  const RouterText(
      {super.key,
      required this.textOne,
      required this.textTwo,
      required this.route});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textOne,
          style: theme.typography.bodyMedium,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: GestureDetector(
              onTap: () {
                Get.offAndToNamed(route);
              },
              child: Text(
                textTwo,
                style: theme.typography.bodyMedium.copyWith(
                    color: theme.primary, fontWeight: FontWeight.w800),
              )),
        )
      ],
    );
  }
}
