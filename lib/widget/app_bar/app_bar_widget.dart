import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/screen/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHome;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.isHome = false,
  }) : super(key: key);

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: theme.primary,
      statusBarIconBrightness: Brightness.light,
    ));
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.primary,),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
                size: 30.sp,
              ),
              onPressed: (){
                Get.to(()=> ProfileScreen());
              },
            ),
            ClipOval(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.phone_solid,
                color: Colors.white,
                size: 30.sp,
              ),
              onPressed: (){
                _handleTelUrl("tel: 0954527580");
              },
            )
          ],
        ),
      ),
    );
  }
  void _handleTelUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }
  @override
  Size get preferredSize => Size.fromHeight(80.h);
}
