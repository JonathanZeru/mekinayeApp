import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/screen/spareparts/spare_part_screen.dart';
import 'package:mekinaye/screen/workshop/workshop_screen.dart';
import 'package:mekinaye/screen/rules/rules_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../config/config_preference.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../layout/home/ads_carousel.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import '../../util/app_constants.dart';
import '../../util/app_routes.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../screen/map/map_screen.dart';
import '../../widget/button.dart';
import '../../widget/custom_snackbar.dart';
import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import '../../layout/error/error_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final GlobalKey<SliderDrawerState> _sliderDrawerKey =
        GlobalKey<SliderDrawerState>();
    late String title;
    final internetController = Get.put(InternetController());
    if (internetController.hasConnection.value == false &&
        internetController.checkingConnection.value == false) {
      return ErrorScreen(onPress: internetController.checkingConnection);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SliderDrawer(
            appBar: SliderAppBar(
              appBarColor: theme.primary,
              title: ClipOval(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"))),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  CupertinoIcons.phone_solid,
                  color: Colors.white,
                  size: 30.sp,
                ),
                onPressed: () {
                  _handleTelUrl("tel: 0954527580");
                },
              ),
            ),
            key: _sliderDrawerKey,
            sliderOpenSize: 179,
            slider: _SliderView(
              onItemClick: (title) {
                _sliderDrawerKey.currentState!.closeSlider();
              },
            ),
            child: Container(
              color: theme.primaryBackground,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  AdsCarousel(),
                  GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: AppConstants.homeScreenGrid.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 1.3),
                      itemBuilder: (context, j) {
                        return GestureDetector(
                          onTap: () {
                            switch (AppConstants.homeScreenGrid[j]['name']) {
                              case "Ethio Spare":
                                Get.to(() => WorkshopScreen());
                                break;
                              case "Ethio Garage":
                                Get.to(() => SparePartScreen());
                                break;
                              case "Traffic Police":
                                pushNewScreen(context,
                                    screen: RulesScreen(isFromHome: true));
                                break;
                              case "Gas Station":
                                Get.to(() => MapScreen());
                                break;
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 50,
                              width: 70,
                              decoration: BoxDecoration(
                                color: theme.accent1,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon(
                                  //   AppConstants.homeScreenGrid[j]['icon'],
                                  //   size: 50.sp,
                                  //   color: Colors.black,
                                  // ),
                                  Image.asset(
                                      AppConstants.homeScreenGrid[j]['image'],
                                      width: 70,
                                      height: 70),
                                  Text(AppConstants.homeScreenGrid[j]['name']!,
                                      style:
                                          theme.typography.titleMedium.copyWith(
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              )),
            )),
      ),
    );
  }
}

void _handleTelUrl(String url) async {
  await launchUrl(Uri.parse(url));
}

class _SliderView extends StatefulWidget {
  final Function(String)? onItemClick;

  const _SliderView({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<_SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<_SliderView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  bool isLoading = true;
  bool isLoggedIn = false;
  late Map<String, dynamic> user;
  Future<void> checkLogin() async {
    setState(() {
      isLoading = true;
    });
    isLoggedIn = await AuthService.isUserLoggedIn();
    if (isLoggedIn) {
      final userProfile = ConfigPreference.getUserProfile();
      setState(() {
        user = userProfile;
      });
    } else {
      user = {"login": "Please Login or Sign up"};
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          ClipOval(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isLoading
              ? CircularProgressIndicator()
              : isLoggedIn
                  ? Text(
                      '${user['firstName']} ${user['lastName']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          '${user['login']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Button(
                            text: "Login in",
                            onPressed: () async {
                              Get.to(() => LoginScreen());
                            },
                            options: ButtonOptions(
                              width: double.infinity,
                              height: 45.h,
                              padding: EdgeInsets.all(10.h),
                              textStyle: theme.typography.titleMedium
                                  .copyWith(color: theme.primaryBtnText),
                            ),
                          ),
                        )
                      ],
                    ),
          const SizedBox(
            height: 20,
          ),
          ...[
            Menu(CupertinoIcons.profile_circled, 'Profile'),
            Menu(Icons.info, 'Privacy policy'),
            Menu(Icons.list_alt, 'Terms and conditions'),
            Menu(Icons.question_mark, 'FAQ'),
            Menu(Icons.settings, 'Setting'),
            isLoggedIn
                ? Menu(Icons.arrow_back_ios, 'LogOut')
                : Menu(Icons.login, 'Login in')
          ]
              .map((menu) => _SliderMenuItem(
                  title: menu.title,
                  iconData: menu.iconData,
                  onTap: (String e) async {
                    if (e == "Profile") {
                      if (isLoggedIn) {
                        Get.to(() => ProfileScreen());
                      } else {
                        Get.to(() => LoginScreen());
                      }
                    }
                    if (e == "LogOut") {
                      if (isLoggedIn) {
                        bool? logoutConfirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Are you sure?",
                                  style: theme.typography.titleMedium.copyWith(
                                      color: theme.primaryText,
                                      fontSize: 16.sp)),
                              content: Text("Do you want to log out?",
                                  style: theme.typography.titleMedium.copyWith(
                                      color: theme.primaryText,
                                      fontSize: 14.sp)),
                              actions: [
                                Button(
                                  text: "No",
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  options: ButtonOptions(
                                      height: 35.h,
                                      width: 60.w,
                                      color: theme.error,
                                      textStyle: theme.typography.titleMedium
                                          .copyWith(
                                              color: theme.primaryBackground,
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
                                      textStyle: theme.typography.titleMedium
                                          .copyWith(
                                              color: theme.primaryBackground,
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
                            onLoading: () {},
                            onSuccess: (response) {},
                            onError: (error) {},
                          );
                          AuthService.logout();
                          Get.offAllNamed(AppRoutes.login);
                        }
                      } else {
                        CustomSnackBar.showCustomSnackBar(
                          title: 'Login',
                          message: 'Please Login or Sign up',
                          duration: Duration(seconds: 2),
                        );
                        Get.to(() => LoginScreen());
                      }
                    }
                    if (e == "Login in") {
                      Get.to(() => LoginScreen());
                    }
                  }))
              .toList(),
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function(String)? onTap;

  const _SliderMenuItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title,
            style: const TextStyle(
                color: Colors.black, fontFamily: 'BalsamiqSans_Regular')),
        leading: Icon(iconData, color: Colors.black),
        onTap: () => onTap?.call(title));
  }
}

class Quotes {
  final MaterialColor color;
  final String author;
  final String quote;

  Quotes(this.color, this.author, this.quote);
}

class Menu {
  final IconData iconData;
  final String title;

  Menu(this.iconData, this.title);
}
