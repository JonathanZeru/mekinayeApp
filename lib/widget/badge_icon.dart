import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {super.key,
      required this.icon,
      this.badgeCount = 0,
      this.showIfZero = false,
      this.badgeColor = Colors.red,
      required TextStyle badgeTextStyle})
      : badgeTextStyle = badgeTextStyle.copyWith(
          color: badgeTextStyle.color ?? Colors.white,
          fontSize: badgeTextStyle.fontSize ?? 10,
        );
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount, context),
    ]);
  }

  Widget badge(int count, BuildContext context) => Positioned(
        right: 0,
        top: 0,
        child: Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(7.5.r),
          ),
          constraints: BoxConstraints(
            minWidth: 16.w,
            minHeight: 16.h,
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: AppTheme.of(context).secondaryBackground,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
