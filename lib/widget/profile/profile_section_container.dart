import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSectionContainer extends StatelessWidget {
  final Widget child;
  final double topMargin;

  const ProfileSectionContainer({
    Key? key,
    required this.child,
    this.topMargin = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: topMargin.h),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
