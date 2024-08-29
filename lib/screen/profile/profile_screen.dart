import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/service/authorization_service.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:mekinaye/widget/button.dart';

import '../../controller/auth/edit_profile_controller.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../layout/profile/profile_header.dart';
import '../../layout/profile/route_list.dart';
import '../../service/api_service.dart';
import '../../util/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController editProfileController =
    Get.put(EditProfileController());
    final userProfile = ConfigPreference.getUserProfile();
    final AppTheme appTheme = AppTheme.of(context);
    final internetController = Get.put(InternetController());
    if(internetController.hasConnection.value == false && internetController.checkingConnection.value == false){
      return ErrorScreen(onPress: internetController.checkingConnection);
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: appTheme.typography.titleLarge.copyWith(
              color: appTheme.primaryText,
              fontSize: 20.0,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Column(
            children: [
              UserProfileHeader(
                firstName:
                editProfileController.firstNameController.text,
                lastName:
                editProfileController.lastNameController.text,
                email: editProfileController.emailController.text,
              ),
              const SizedBox(height: 20),
              const RouteList(),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Button(
                    showLoadingIndicator: false,
                    text: "Log out",
                    icon: Icon(Icons.logout, color: appTheme.primaryBackground),
                    onPressed: () async {
                      bool? logoutConfirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Are you sure?",
                                style: appTheme.typography.titleMedium.copyWith(
                                    color: appTheme.primaryText, fontSize: 16.sp)),
                            content: Text("Do you want to log out?",
                                style: appTheme.typography.titleMedium.copyWith(
                                    color: appTheme.primaryText, fontSize: 14.sp)),
                            actions: [
                              Button(
                                text: "No",
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                options: ButtonOptions(
                                    height: 35.h,
                                    width: 60.w,
                                    color: appTheme.error,
                                    textStyle: appTheme.typography.titleMedium
                                        .copyWith(
                                        color: appTheme.primaryBackground,
                                        fontSize: 14.sp)),
                              ),
                              SizedBox(width: 10.w),
                              Button(
                                text: "Yes",
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                options: ButtonOptions(
                                    height: 35.h,
                                    width: 60.w,
                                    textStyle: appTheme.typography.titleMedium
                                        .copyWith(
                                        color: appTheme.primaryBackground,
                                        fontSize: 14.sp)),
                              ),
                            ],
                          );
                        },
                      );

                      if (logoutConfirmed == true) {
                        final userProfile = ConfigPreference.getUserProfile();
                        Map<String, dynamic> body = {
                          "userId": userProfile['id'],
                          "fcmToken": ""
                        };

                        await ApiService.safeApiCall(
                          "${AppConstants.url}/users/update-token",
                          RequestType.post,
                          data: body,
                          onLoading: () {
                          },
                          onSuccess: (response) {

                          },
                          onError: (error) {

                          },
                        );
                        AuthService.logout();
                        Get.offAllNamed(AppRoutes.login);
                      }
                    },
                    options: ButtonOptions(
                      height: 45.h,
                      padding: EdgeInsets.all(10.h),
                      textStyle: appTheme.typography.titleMedium
                          .copyWith(color: appTheme.primaryBackground),
                    ),
                                    ),
                  ),
                  SizedBox(width: 10.h),
                  Expanded(
                    child: Button(
                      showLoadingIndicator: false,
                      text: "Delete Account",
                      icon: Icon(CupertinoIcons.trash, color: appTheme.primary),
                      onPressed: () async {
                        bool? deleteConfirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure?",
                                  style: appTheme.typography.titleMedium.copyWith(
                                      color: appTheme.primaryText, fontSize: 16.sp)),
                              content: Text("Do you want to delete your account?",
                                  style: appTheme.typography.titleMedium.copyWith(
                                      color: appTheme.primaryText, fontSize: 14.sp)),
                              actions: [
                                Button(
                                  text: "No",
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  options: ButtonOptions(
                                      height: 35.h,
                                      width: 60.w,
                                      color: Colors.transparent,
                                      borderSide: BorderSide(
                                          color: appTheme.primary, width: 2),
                                      textStyle: appTheme.typography.titleMedium
                                          .copyWith(
                                          color: appTheme.primaryBackground,
                                          fontSize: 14.sp)),
                                ),
                                SizedBox(width: 10.w),
                                Button(
                                  text: "Yes",
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  options: ButtonOptions(
                                      height: 35.h,
                                      width: 60.w,
                                      textStyle: appTheme.typography.titleMedium
                                          .copyWith(
                                          color: appTheme.primaryBackground,
                                          fontSize: 14.sp)),
                                ),
                              ],
                            );
                          },
                        );

                        if (deleteConfirmed == true) {
                          final userProfile = ConfigPreference.getUserProfile();
                          Map<String, dynamic> body = {
                            "userId": userProfile['id'],
                            "fcmToken": ""
                          };

                          await ApiService.safeApiCall(
                            "${AppConstants.url}/users/update-token",
                            RequestType.post,
                            data: body,
                            onLoading: () {
                            },
                            onSuccess: (response) {

                            },
                            onError: (error) {

                            },
                          );
                          editProfileController.deleteAccount();
                          AuthService.logout();
                          Get.offAllNamed(AppRoutes.login);
                        }
                      },
                      options: ButtonOptions(
                        elevation: 0,
                        color: Colors.transparent,
                        borderSide: BorderSide(color: appTheme.primary, width: 2),
                        height: 45.h,
                        padding: EdgeInsets.all(10.h),
                        textStyle: appTheme.typography.titleMedium
                            .copyWith(color: appTheme.primary),
                      ),
                    ),
                  ),],
              )
            ],
          ),
        ),
      ),
    );
  }
}
