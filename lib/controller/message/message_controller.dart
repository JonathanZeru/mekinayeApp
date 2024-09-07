import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart' as flutter_sound;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mekinaye/config/config_preference.dart';
import 'package:mekinaye/model/api_exceptions.dart';
import 'package:mekinaye/model/message.dart';
import 'package:mekinaye/model/user.dart';
import 'package:mekinaye/service/api_service.dart';
import 'package:mekinaye/util/api_call_status.dart';
import 'package:mekinaye/util/app_constants.dart'; // Add this for voice recording
import 'package:http/http.dart' as http;
import 'package:mekinaye/widget/custom_snackbar.dart';
// Import for Timer

class MessageController extends GetxController {
  var messages = <Message>[].obs;
  final ImagePicker _picker = ImagePicker();

  final isPlaying = <bool>[].obs;
  int currentPlayingIndex = -1;
  File? selectedImage;
  File? selectedAudio;

  late final int ownerId;
  var receiverName = ''.obs;
  var receiverId = ''.obs;
  var receiverUserName = ''.obs;
  var userId = ''.obs;
  var textController = TextEditingController();
  var msgScrolling = ScrollController();
  late UserModel receiverData;

  flutter_sound.FlutterSoundRecorder? _recorder;

  Timer? messagePollingTimer;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;

  RxBool hasConnection = true.obs;
  RxBool checkingConnection = true.obs;

  // late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  RxBool isRecording = false.obs;
  // RxBool recodingNow = true.obs;
  String audioPath = "";
  RxBool playing = false.obs;
  RxBool isSending = false.obs;
  RxInt spareId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = ConfigPreference.getUserProfile()['id'].toString();
    audioPlayer = AudioPlayer();
    checkConnection();
    audioPlayer.onPlayerStateChanged.listen((audioplayers.PlayerState state) {
      if (state == audioplayers.PlayerState.completed) {
        if (currentPlayingIndex != -1) {
          isPlaying[currentPlayingIndex] = false;
          currentPlayingIndex = -1;
        }
      }
    });
    startMessagePolling();
  }

  assignSparePartId(int sparePartId) {
    print("sparePartId = $sparePartId");
    spareId.value = sparePartId;
    update();
  }

  Future<void> checkConnection() async {
    checkingConnection.value = true;
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    hasConnection.value = isConnected;
    checkingConnection.value = false;
  }

  void startMessagePolling() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    messagePollingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (isConnected) {
        fetchMessages(receiverData, spareId.value);
      } else {
        Get.snackbar('Error', 'No Connection');
        messagePollingTimer?.cancel();
        hasConnection.value = false;
      }
    });
  }

  void stopMessagePolling() {
    messagePollingTimer?.cancel();
  }

  @override
  void onClose() {
    // audioRecord.dispose();
    audioPlayer.dispose();
    stopMessagePolling();
    messages.value = [];
    super.onClose();
  }

  void setReceiverData(UserModel receiverDataModel) {
    receiverData = receiverDataModel;
  }

  void fetchReceiverData(int ownerId) async {
    try {
      final response =
          await http.get(Uri.parse('${AppConstants.url}/users/$ownerId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        receiverName.value = "${data['firstName']} ${data['lastName']}";
        receiverId.value = data['id'].toString();
        receiverUserName.value = data['userName'];
        UserModel owner = UserModel(id: ownerId);
        fetchMessages(owner, spareId.value);
      } else {
        print("FAILED TO LOAD USER DATA");
      }
    } catch (e) {
      print("FETCH USER DATA ERROR: $e");
    }
  }

  void fetchMessages(UserModel owner, int sparePartId) async {
    checkConnection();
    receiverData = owner;
    Map<String, dynamic> userProfile = ConfigPreference.getUserProfile();
    spareId.value = sparePartId;
    print(
        '${'${AppConstants.url}/messages/get-both-chats?senderId=${userProfile['id']}&receiverId=${receiverData.id}&sparePartId=${spareId.value}'}');
    try {
      final response = await http.get(
        Uri.parse(
            '${AppConstants.url}/messages/get-both-chats?senderId=${userProfile['id']}&receiverId=${receiverData.id}&sparePartId=${spareId.value}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        messages.value = data
            .map((item) => Message.fromJson(item))
            .toList()
            .reversed
            .toList();
      } else {
        print("FAILED TO FETCH MESSAGES");
      }
    } catch (e) {
      print("FETCH MESSAGES ERROR: $e");
    }
  }

  Future<void> sendMessage(bool isAudio) async {
    final userProfile = ConfigPreference.getUserProfile();
    print("sendMessage");
    if (isAudio) {
      // Handle audio sending here
    } else {
      print('spareId.value = ${spareId.value}');
      if (selectedImage == null && selectedAudio == null) {
        await ApiService.safeApiCall(
          "${AppConstants.url}/messages/send",
          RequestType.post,
          data: jsonEncode({
            "text": textController.text.isNotEmpty ? textController.text : "",
            "image": null,
            "audio": null,
            "senderId": userProfile['id'],
            "receiverId": receiverData.id,
            "sparePartId": spareId.value,
            "senderUsername": userProfile['userName'],
            "receiverUsername": receiverData.userName
          }),
          onLoading: () {
            update();
          },
          onSuccess: (response) async {
            textController.text = "";
            selectedImage = null;
            selectedAudio = null;
            fetchMessages(receiverData, spareId.value);
            apiCallStatus.value = ApiCallStatus.success;
            update();
          },
          onError: (error) {
            ApiService.handleApiError(error);
            apiException.value = error;
            apiCallStatus.value = ApiCallStatus.error;
            CustomSnackBar.showCustomErrorToast(
              title: 'Error',
              message: 'Failed to send message: $error',
              duration: Duration(seconds: 2),
            );
            textController.text = "";
            selectedImage = null;
            selectedAudio = null;
            fetchMessages(receiverData, spareId.value);
            update();
          },
        );
      } else {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AppConstants.url}/messages/send'),
        );

        request.fields['senderId'] = userProfile['id'].toString();
        request.fields['receiverId'] = receiverData.id.toString();
        request.fields['sparePartId'] = spareId.value.toString();
        request.fields['senderUsername'] = userProfile['userName'];
        request.fields['receiverUsername'] = receiverData.userName!;
        request.fields['text'] = "null";
        request.fields['audio'] = "null";
        var imageStream = http.ByteStream(selectedImage!.openRead());
        var imageLength = await selectedImage!.length();
        var imageFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: selectedImage!.path.split('/').last,
        );
        request.files.add(imageFile);
        // if (selectedImage != null) {
        request.files.add(imageFile);
        // } else {
        // request.fields['image'] = "null";
        try {
          // }
          var response = await request.send();
          var responseString = await response.stream.bytesToString();
          if (response.statusCode == 201) {
            textController.text = "";
            selectedImage = null;
            selectedAudio = null;
            fetchMessages(receiverData, spareId.value);
          } else {
            // Handle non-201 responses
          }
        } catch (e) {
          Get.snackbar('Error', 'An error occurred: $e');
        }
      }
    }
  }

  void imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      sendMessage(false);
    }
  }

  void imageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      sendMessage(false);
    }
  }

  void toggleMessageAudioPlayPause(int index) async {
    if (index < 0 || index >= messages.length) return;

    final messageIndex = index;

    if (currentPlayingIndex != -1 && currentPlayingIndex != messageIndex) {
      await audioPlayer.stop();
      isPlaying[currentPlayingIndex] = false;
    }

    if (isPlaying[messageIndex]) {
      await audioPlayer.pause();
      isPlaying[messageIndex] = false;
    } else {
      await audioPlayer.play(UrlSource(messages[messageIndex].audioUrl!));
      isPlaying[messageIndex] = true;
      currentPlayingIndex = messageIndex;
    }
  }
}
