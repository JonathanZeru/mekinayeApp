import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/config/themes/theme_manager.dart';
import 'package:mekinaye/screen/message/message_screen.dart';
import 'package:mekinaye/service/authorization_service.dart';
import 'package:mekinaye/service/firebase_Service.dart';
import 'package:mekinaye/util/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'model/user.dart';

///init firebase
final navigatorKey = GlobalKey<NavigatorState>();

// ...

Future<void> main() async {
  /// wait for bindings
  WidgetsFlutterBinding.ensureInitialized();

  /// init shared preference
  await ConfigPreference.init();

  /// init image caching
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isLoggedIn = await AuthService.isUserLoggedIn();

  print("here");
  await FirebaseService().init(isLoggedIn);
  print("here");

  /// check if user is logged in//Todo move to splash screen

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    bool isFirstLaunch =
        ConfigPreference.isFirstLaunch(); //Todo move to splash screen

    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, _) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: LightModeTheme().themeData,
            darkTheme: DarkModeTheme().themeData,
            themeMode: ThemeManager.getThemeMode(),
            getPages: AppRoutes.pages,
            routes: {
              '/messageScreen': (context) {
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>;
                print("args = $args");
                return MessagingScreen(
                    ownerId: 0, owner: UserModel(), args: args);
              }, // Replace with actual data or use arguments
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/messageScreen') {
                final messageId = settings.arguments
                    as int; // Adjust type based on your arguments
                return MaterialPageRoute(
                  builder: (context) => MessagingScreen(
                      // Pass the messageId or other data here
                      ownerId: messageId,
                      owner: UserModel(),
                      args: {'isFromNotification': false}),
                );
              }
              return null;
            },
            initialRoute: isFirstLaunch
                ? AppRoutes.welcome
                : isLoggedIn
                    ? AppRoutes.initial
                    : AppRoutes.login
            // initialRoute: AppRoutes.welcome
            ));
  }
}
