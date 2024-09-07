import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/chat_list/chat_list_controller.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../model/message.dart';
import '../../model/user.dart';
import '../../service/authorization_service.dart';
import '../../util/date.dart';
import '../../widget/button.dart';
import '../../widget/loading.dart';
import '../auth/login_screen.dart';
import '../message/message_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final internetController = Get.put(InternetController());
  final controller = Get.put(ChatListController());
  bool hasConnection = true;
  bool checkingConnection = true;

  @override
  void initState() {
    checkConnection();
  }

  Future<void> checkConnection() async {
    setState(() {
      checkingConnection = true;
    });
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      controller.fetchUsersAndLastMessages();
      setState(() {
        hasConnection = true;
        checkingConnection = false;
      });
    } else {
      setState(() {
        hasConnection = false;
        checkingConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    if (checkingConnection == true) {
      return SafeArea(
        child: Scaffold(
          body: Center(child: Loading()),
        ),
      );
    }
    if (hasConnection == false) {
      return ErrorScreen(onPress: checkConnection);
    }
    if (hasConnection == false && checkingConnection == false) {
      return ErrorScreen(onPress: checkConnection);
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchUsersAndLastMessages();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: Loading());
          }

          if (controller.isLoggedIn.value == false &&
              !controller.isLoading.value) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login or Sign up",
                    style: theme.typography.titleMedium.copyWith(
                      color: theme.primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "to see your chat list.",
                    style: theme.typography.titleMedium.copyWith(
                      color: theme.primaryText,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Button(
                    text: "Login",
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    options: ButtonOptions(
                      width: double.infinity,
                      height: 45.h,
                      padding: EdgeInsets.all(10.h),
                      textStyle: theme.typography.titleMedium.copyWith(
                        color: theme.primaryBtnText,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.users.isEmpty && !controller.isLoading.value) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No chat list",
                    style: theme.typography.titleMedium.copyWith(
                      color: theme.primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          if (controller.isLoading.value == true) {
            return Center(child: Loading());
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              final lastMessage = controller.lastMessages[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(user.userName![0]),
                      ),
                      title: Text(user.userName!),
                      subtitle: lastMessage.text != 'null'
                          ? Text(lastMessage.text!, maxLines: 2)
                          : (lastMessage.audioUrl != 'null'
                              ? Icon(Icons.audiotrack)
                              : null),
                      trailing: Text(duTimeLineFormat(lastMessage.createdAt!)),
                      onTap: () {
                        Get.to(() => MessagingScreen(
                              sparePartId: lastMessage.sparePartId!,
                              brandName: "",
                              sparePartName: "",
                              ownerId: user.id!,
                              owner: user,
                              args: {'isFromNotification': false},
                            ));
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Your chat for ${lastMessage.sparePart!.name}",
                      style: theme.typography.titleMedium,
                    ),
                  )
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
