import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/data/app_theme.dart';

class StatisticsCard extends StatelessWidget {
  String name;
  String point;

  StatisticsCard({super.key, required this.name, required this.point});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 150.w,
        height: 200.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                point,
                style: theme.typography.labelLarge.copyWith(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 25
                )),
            Text(
                name,
                style: theme.typography.labelLarge.copyWith(
                    color: theme.primaryText,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ))

          ],
        ),
      ),
    );
  }
}
