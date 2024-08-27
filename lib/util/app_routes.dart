import 'package:get/get.dart';

import 'package:mekinaye/screen/auth/login_screen.dart';
import 'package:mekinaye/screen/auth/signup_screen.dart';
import 'package:mekinaye/screen/home/home_screen.dart';
import 'package:mekinaye/screen/main_layout_screen.dart';
import 'package:mekinaye/screen/message/message_screen.dart';
import 'package:mekinaye/screen/profile/edit_profile_screen.dart';
import 'package:mekinaye/screen/profile/profile_screen.dart';
import 'package:mekinaye/screen/welcome/welcome_screen.dart';

import '../screen/chat/chat_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const example = '/example';
  static const welcome = '/welcome';
  static const initial = '/main-screen';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const chat = '/chat-list';
  static const profile = '/profile';
  static const editProfile = '/edit-profile';
  static const messaging = '/message';

  static final pages = [
    GetPage(name: initial, page: () => const MainLayoutScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const SignupScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: chat, page: () => ChatListScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: editProfile, page: () => const EditProfileScreen())
  ];
}
