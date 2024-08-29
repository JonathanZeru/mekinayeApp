import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../controller/message/message_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../layout/message/chat_list.dart';
import '../../model/user.dart';

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../util/app_constants.dart';

class MessagingScreen extends StatefulWidget {
  final int ownerId;
  final UserModel owner;
  final Map<String, dynamic> args;

  const MessagingScreen(
      {super.key,
      required this.ownerId,
      required this.owner,
      required this.args});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final controller = Get.put(MessageController());
  bool isSending = false;
  bool recodingNow = true;
  @override
  Widget build(BuildContext context) {
    final internetController = Get.put(InternetController());

    AppTheme theme = AppTheme.of(context);
    controller.setReceiverData(widget.owner);
    if (widget.args['isFromNotification']) {
      controller.fetchReceiverData(widget.args['receiverId']);
    } else {
      controller.fetchMessages(widget.owner);
    }
    if (internetController.hasConnection.value == false &&
        internetController.checkingConnection.value == false) {
      return ErrorScreen(onPress: internetController.checkingConnection);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${controller.receiverData.firstName!} ${controller.receiverData.lastName!}"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(),
            ),
            // isSending
            //     ? Container(
            //         padding: EdgeInsets.all(16.0),
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text('Sending audio...'),
            //             SizedBox(height: 10),
            //             LinearProgressIndicator(
            //                 value: controller.uploadProgress.value),
            //           ],
            //         ),
            //       )
            //     : Container(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 6,
                      controller: controller.textController,
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        prefixIcon: IconButton(
                          icon: Icon(Icons.photo, size: 25, color: Colors.blue),
                          onPressed: () {
                            showPicker(context);
                          },
                        ),
                        hintText: "Send messages...",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     recodingNow
                  //         ? Obx(() => IconButton(
                  //               icon: controller.isRecording.value
                  //                   ? const Icon(Icons.fiber_manual_record,
                  //                       color: Colors.red, size: 25)
                  //                   : const Icon(Icons.mic_none,
                  //                       color: Colors.red, size: 25),
                  //               onPressed: controller.isRecording.value
                  //                   ? () {
                  //                       controller.stopRecording();
                  //                       setState(() {
                  //                         recodingNow = false;
                  //                       });
                  //                     }
                  //                   : controller.startRecording,
                  //             ))
                  //         : Obx(() => Row(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 IconButton(
                  //                   icon: controller.playing.value
                  //                       ? Icon(Icons.pause_circle,
                  //                           color: Colors.green, size: 25)
                  //                       : Icon(Icons.play_circle,
                  //                           color: Colors.green, size: 25),
                  //                   onPressed: controller.playing.value
                  //                       ? controller.pauseRecording
                  //                       : controller.playRecording,
                  //                 ),
                  //                 IconButton(
                  //                   icon: const Icon(Icons.delete,
                  //                       color: Colors.red, size: 25),
                  //                   onPressed: () {
                  //                     controller.deleteRecording();
                  //                     setState(() {
                  //                       recodingNow = true;
                  //                     });
                  //                   },
                  //                 ),
                  //                 IconButton(
                  //                   icon: const Icon(Icons.send_outlined,
                  //                       color: Colors.green, size: 25),
                  //                   onPressed: () async {
                  //                     setState(() {
                  //                       isSending = true;
                  //                     });
                  //                     await controller.sendMessage(true);
                  //                     setState(() {
                  //                       recodingNow = true;
                  //                       isSending = false;
                  //                     });
                  //                   },
                  //                 )
                  //               ],
                  //             )),
                  //   ],
                  // ),
                  IconButton(
                    icon: Icon(Icons.send, size: 25, color: Colors.blue),
                    onPressed: () {
                      controller.sendMessage(false);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  controller.imageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  controller.imageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
