import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/themes/data/app_theme.dart';

class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({
    Key? key,
    required this.imageUrl,
    this.topLeftCurve = false,
  }) : super(key: key);

  final String imageUrl;
  final bool topLeftCurve;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Container(
      color: theme.primary,
      child: Column(
        children: [
          Container(
            height: 758.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 94.h,
            decoration: BoxDecoration(
              borderRadius: topLeftCurve
                  ? BorderRadius.only(
                      topLeft: Radius.circular(theme.radius * 6))
                  : null,
              color: theme.secondaryBackground,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  right: 50.w, bottom: 30.h, left: 60.w, top: 20.h),
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
