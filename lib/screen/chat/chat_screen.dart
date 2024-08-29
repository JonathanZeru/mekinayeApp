import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/chat_list/chat_list_controller.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../model/message.dart';
import '../../model/user.dart';
import '../../service/authorization_service.dart';
import '../../util/date.dart';
import '../../widget/button.dart';
import '../auth/login_screen.dart';
import '../message/message_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final internetController = Get.put(InternetController());
    final controller = Get.put(ChatListController());
    AppTheme theme =AppTheme.of(context);
    if(internetController.hasConnection.value == false && internetController.checkingConnection.value == false){
      return ErrorScreen(onPress: () async {
        controller.isLoggedIn.value =
            await AuthService.isUserLoggedIn();
        bool isConnected = await InternetConnectionChecker().hasConnection;
        if(isConnected){
          if(controller.isLoggedIn.value) {
            controller.fetchUsersAndLastMessages();
          }
        }
      });
    }
    return Scaffold(
      body:RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUsersAndLastMessages(); // Call your refresh function
          },
          child:  Obx(() {
            if(controller.isLoading.value){
              return Center(child: CircularProgressIndicator());
            }
            if(controller.isLoggedIn.value == false){
              return Center(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Login or Sign up",
                    style: theme.typography.titleMedium.copyWith(
                        color: theme.primaryText,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10.h,),Text(
                    "to see the chat your list.",
                    style: theme.typography.titleMedium.copyWith(
                        color: theme.primaryText,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Button(
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
                  )

                ],
              ));
            }
        if (controller.users.isEmpty && controller.isLoading.value == false) {

          return Center(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "No chat list",
                style: theme.typography.titleMedium.copyWith(
                    color: theme.primaryText,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                ),
              )

            ],
          ));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: controller.users.length,
          itemBuilder: (context, index) {
            final user = controller.users[index];
            final lastMessage = controller.lastMessages[index];

            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(user.userName![0]),
                ),
                title: Text(user.userName!),
                subtitle: lastMessage.text != 'null'
                    ? Text(lastMessage.text!, maxLines: 2,)
                    : (lastMessage.audioUrl != 'null'
                    ? Icon(Icons.audiotrack)
                    : null),
                trailing: Text(duTimeLineFormat(lastMessage.createdAt!)), // Show formatted date
                onTap: () {
                  Get.to(() => MessagingScreen(
                      ownerId: user.id!,
                      owner: user,
                      args: {'isFromNotification': false}));
                },
              ),
            );
          },
        );


      }))
    );
  }
}
