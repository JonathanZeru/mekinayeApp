import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/config/themes/theme_manager.dart';
import 'package:mekinaye/generated/assets.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/custom_divider.dart';
import 'package:mekinaye/widget/profile/profile_reusable_list_tile.dart';
import 'package:mekinaye/widget/svg_icon.dart';

class GeneralLayout extends StatelessWidget {
  const GeneralLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(
            "General",
            style: theme.typography.titleMedium
                .copyWith(color: theme.accent5, fontSize: 16.sp),
          ),
        ),
        const CustomDivider(),
        ProfileReusableListTile(
          leading: ConfigPreference.getThemeIsLight()
              ? Icon(CupertinoIcons.sun_min_fill, color: theme.primary)
              : Icon(CupertinoIcons.moon_fill, color: theme.primary),
          title: "Theme",
          trailing: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.primaryBtnText.withOpacity(0.2),
                  spreadRadius: theme.radius * 0.4,
                  blurRadius: theme.radius,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: FlutterSwitch(
              width: 55.0,
              height: 30.0,
              value: !ConfigPreference.getThemeIsLight(),
              activeColor: theme.primary,
              inactiveColor: theme.accent2,
              onToggle: (val) => ThemeManager.changeTheme(),
            ),
          ),
          onTap: () {},
        ),
        ProfileReusableListTile(
          leading: Icon(CupertinoIcons.bell_fill, color: theme.primary),
          title: "Notification",
          trailing: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.primaryBtnText.withOpacity(0.2),
                  spreadRadius: theme.radius * 0.4,
                  blurRadius: theme.radius,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: FlutterSwitch(
              width: 55.0,
              height: 30.0,
              value: true,
              activeColor: theme.primary,
              inactiveColor: theme.accent2,
              onToggle: (val) {

              },
            ),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}
