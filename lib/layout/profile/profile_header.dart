import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/controller/profile/edit_profile_controller.dart';
import 'package:mekinaye/generated/assets.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/button.dart';

import '../../controller/auth/edit_profile_controller.dart';

class UserProfileHeader extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  const UserProfileHeader({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  UserProfileHeaderState createState() => UserProfileHeaderState();
}

class UserProfileHeaderState extends State<UserProfileHeader> {
  late EditProfileController editProfileController;

  @override
  void initState() {
    super.initState();
    editProfileController = Get.put(EditProfileController());
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    String formattedName =
        "${widget.firstName.capitalize} ${widget.lastName.capitalize}.";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.profile_circled,
            color: theme.primary,
            size: 30.sp,
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formattedName,
                  style: theme.typography.labelLarge.copyWith(
                    color: theme.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email,
                  style: theme.typography.labelLarge.copyWith(
                    color: theme.primaryText
                  ),
                ),
              ],
            ),
          ),
          Button(
            options: ButtonOptions(width: 100.w),
            onPressed: () {
              Get.toNamed(AppRoutes.editProfile);
            },
            text: "Edit",
          )
        ],
      ),
    );
  }

  // Helper method to format creation date
  String _formatCreatedAt(String createdAt) {
    DateTime joinedDate = DateTime.parse(createdAt);
    String formattedDate =
        "${_getMonthName(joinedDate.month)} ${joinedDate.year}";
    return "Joined $formattedDate";
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }
}
