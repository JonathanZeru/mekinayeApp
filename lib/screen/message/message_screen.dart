import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import '../../controller/connection/internet_connection_controller.dart';
import '../../controller/message/message_controller.dart';
import '../../layout/error/error_screen.dart';
import '../../layout/message/chat_list.dart';
import '../../model/user.dart';
import 'package:audioplayers/audioplayers.dart';

class MessagingScreen extends StatefulWidget {
  final int ownerId;
  final UserModel owner;
  final Map<String, dynamic> args;

  const MessagingScreen({super.key, required this.ownerId, required this.owner, required this.args});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final controller = Get.put(MessageController());
  // late Record audioRecord;
  // late AudioPlayer audioPlayer;
  // bool isRecording = false;
  // String audioPath = "";
  //
  // @override
  // void initState() {
  //   super.initState();
  //   audioPlayer = AudioPlayer();
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   audioRecord.dispose();
  //   audioPlayer.dispose();
  // }
  // bool playing=false;
  // Future<void> startRecording() async {
  //   try {
  //     print("START RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
  //     if (await audioRecord.hasPermission()) {
  //
  //       await audioRecord.start();
  //       setState(() {
  //         isRecording = true;
  //       });
  //     }
  //   } catch (e, stackTrace) {
  //     print("START RECODING+++++++++++++++++++++${e}++++++++++${stackTrace}+++++++++++++++++");
  //   }
  // }
  //
  // Future<void> stopRecording() async {
  //   try {
  //     print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
  //     String? path = await audioRecord.stop();
  //     setState(() {
  //       recoding_now=false;
  //       isRecording = false;
  //       audioPath = path!;
  //     });
  //   } catch (e) {
  //     print("STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final internetController = Get.put(InternetController());

    AppTheme theme = AppTheme.of(context);
    controller.setReceiverData(widget.owner);
    if(widget.args['isFromNotification']){
      controller.fetchReceiverData(widget.args['receiverId']);
    }else {
      controller.fetchMessages(widget.owner);
    }
    if(internetController.hasConnection.value == false && internetController.checkingConnection.value == false){
      return ErrorScreen(onPress: internetController.checkingConnection);
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${controller.receiverData.firstName!} ${controller.receiverData.lastName!}")
        ),
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(
              children: [
                ChatList(),
                Positioned(
                  bottom: 0,
                  height: 60,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,
                            maxLines: 2,
                            controller: controller.textController,
                            decoration: InputDecoration(
                              hintText: "Send messages...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.photo, size: 25, color: Colors.blue),
                          onPressed: () {
                            showPicker(context);
                          },
                        ),
                        SizedBox(width: 10),
                        // Obx(()
                        // {
                        //   if(controller.isRecording.value){
                        //     return IconButton(
                        //       icon: Icon(Icons.stop, size: 25, color: Colors.red),
                        //       onPressed: controller.stopRecording,
                        //     );
                        //
                        //   }else{
                        //     return IconButton(
                        //       icon: Icon(Icons.mic, size: 25, color: Colors.blue),
                        //       onPressed: controller.startRecording,
                        //     );
                        //   }
                        // }),
                        IconButton(
                          icon: Icon(Icons.send, size: 25, color: Colors.blue),
                          onPressed: controller.sendMessage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
