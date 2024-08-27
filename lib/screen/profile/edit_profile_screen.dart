import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth/edit_profile_controller.dart';
import '../../layout/profile/edit_profile_actions.dart';
import '../../layout/profile/edit_profile_form.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<EditProfileController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 50.h),
          child: ListView(
            children: [
              const EditProfileForm(),
              SizedBox(
                height: 30.h,
              ),
              const EditProfileActions()
            ],
          ),
        ),
      ),
    );
  }
}
