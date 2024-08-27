import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/custom_divider.dart';
import 'package:mekinaye/widget/profile/profile_reusable_list_tile.dart';

class OtherLayout extends StatelessWidget {
  const OtherLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);

    return Column(
      children: [
        // Title
        ListTile(
          title: Text(
            "Other",
            style: theme.typography.titleMedium
                .copyWith(color: theme.accent5, fontSize: 16),
          ),
        ),
        // FAQ
        ProfileReusableListTile(
          leading: Icon(CupertinoIcons.question_circle, color: theme.primary),
          title: "FAQ",
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15.sp),
          onTap: () {
            // Get.toNamed(AppRoutes.faqScreen)
          },
        ),
        const CustomDivider(),
        // Terms and Conditions
        ProfileReusableListTile(
          leading: Icon(CupertinoIcons.exclamationmark_octagon_fill,
              color: theme.primary),
          title: "Terms and Conditions",
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15.sp),
          onTap: () {
            // Get.toNamed(AppRoutes.termsAndConditions)
          },
        ),
        const CustomDivider(),
        // Privacy Policy
        ProfileReusableListTile(
          leading: Icon(Icons.privacy_tip_rounded, color: theme.primary),
          title: "Privacy Policy",
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 15.sp),
          onTap: () {
            // Get.toNamed(AppRoutes.privacyAndPolicy)
          },
        ),
      ],
    );
  }
}
