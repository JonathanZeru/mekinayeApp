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

import '../../screen/profile/change_password_screen.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);

    return Column(
      children: [
        ListTile(
          title: Text(
            "Profile",
            style: theme.typography.titleMedium
                .copyWith(color: theme.accent5, fontSize: 16.sp),
          ),
        ),
        const CustomDivider(),
        ProfileReusableListTile(
          leading: Icon(CupertinoIcons.padlock_solid, color: theme.primary),
          title: "Change Password",
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () {
            Get.to(()=>ChangePasswordScreen());
          },
        ),
      ],
    );
  }
}
