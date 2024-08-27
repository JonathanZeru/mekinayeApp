import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

class ProfileReusableListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileReusableListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: theme.typography.titleMedium.copyWith(
          color: theme.primaryText,
          fontSize: 16.sp,
        ),
      ),
      subtitle: Text(
        subtitle ?? '',
        style: theme.typography.titleSmall.copyWith(
            color: theme.accent5, fontSize: 14.sp, fontWeight: FontWeight.w100),
      ),
      trailing: trailing != null
          ? SizedBox(
              width: 50.w,
              child: trailing,
            )
          : null,
      onTap: onTap,
    );
  }
}
