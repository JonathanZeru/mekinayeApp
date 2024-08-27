import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:mekinaye/util/app_constants.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter_sound/flutter_sound.dart' as flutter_sound; // Add this for voice recording

import '../../config/config_preference.dart';
import '../../model/api_exceptions.dart';
import '../../model/message.dart';
import '../../model/user.dart';
import '../../service/api_service.dart';
import '../../service/authorization_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

import '../../util/api_call_status.dart';
import '../../widget/custom_snackbar.dart'; // Import for Timer
import 'package:permission_handler/permission_handler.dart';

class MessageController extends GetxController {
  var messages = <Message>[].obs;
  final ImagePicker _picker = ImagePicker();
  final audioPlayer = audioplayers.AudioPlayer();
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

  flutter_sound.FlutterSoundRecorder? _recorder;  // Voice recorder
  RxBool isRecording = false.obs;
  Timer? messagePollingTimer;
  final apiCallStatus = ApiCallStatus.holding.obs;
  final apiException = ApiException().obs;


  RxBool hasConnection = true.obs;
  RxBool checkingConnection = true.obs;
  @override
  void onInit() {
    super.onInit();
    userId.value = ConfigPreference.getUserProfile()['id'].toString();
    checkConnection();
    _recorder = flutter_sound.FlutterSoundRecorder();
    _recorder?.openRecorder();
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
  Future<void> checkConnection() async {
    checkingConnection.value = true;
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      hasConnection.value = true;
    } else {
      hasConnection.value = false;
    }
    checkingConnection.value = false;
  }
  void startMessagePolling() {
    messagePollingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      fetchMessages(receiverData);
    });
  }

  void stopMessagePolling() {
    messagePollingTimer?.cancel();
  }
  @override
  void onClose() {
    _recorder?.closeRecorder();
    stopMessagePolling();
    super.onClose();
  }

  // void startRecording() async {
  //   if (_recorder!.isStopped) {
  //     await _recorder?.startRecorder(toFile: 'voice_message.aac');
  //     isRecording = true;
  //     update();
  //   }
  // }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      // Request the permission
      status = await Permission.microphone.request();
    }

    if (status.isGranted) {
      // The permission is granted, you can start recording
    } else {
      // Permission is denied, handle accordingly
      Get.snackbar('Permission Denied', 'Microphone permission is required to record audio.');
    }
  }

  void startRecording() async {
    final status = await Permission.microphone.status;

    if (!status.isGranted) {
      // Inform the user that microphone access is needed
      await requestMicrophonePermission();
      Get.snackbar('Permission Required', 'Please grant microphone access to record audio.');
      return;
    }

    try {
      await _recorder?.startRecorder(toFile: 'voice_message.aac');
      isRecording.value = true;
      update();
    } catch (e) {
      // Handle the exception
      print("Error starting recorder: $e");
    }
  }

  void stopRecording() async {
    if (_recorder!.isRecording) {
      String? path = await _recorder?.stopRecorder();
      isRecording.value = false;
      selectedAudio = File(path!);
      sendMessage();
      update();
    }
  }

  void setReceiverData(UserModel receiverDataModel){
    receiverData = receiverDataModel;
  }
  void fetchReceiverData(int ownerId) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.url}/users/$ownerId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        receiverName.value = "${data['firstName']} ${data['lastName']}";
        receiverId.value = data['id'].toString();
        receiverUserName.value = data['userName'];
        UserModel owner = UserModel(id: ownerId);
        fetchMessages(owner);
      } else {
        print("Failed to load user data");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void fetchMessages(UserModel owner) async {
    checkConnection();
    receiverData = owner;
    final accessToken = ConfigPreference.getAccessToken();
    Map<String, dynamic> userProfile = ConfigPreference.getUserProfile();

    try {
      final response = await http.get(
        Uri.parse('${AppConstants.url}/messages/get-both-chats?senderId=${userProfile['id']}&receiverId=${receiverData.id}'),
        headers: {
          'Authorization': 'Bearer ${accessToken}',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        messages.value = data.map((item) => Message.fromJson(item)).toList().reversed.toList();
        isPlaying.value = List<bool>.filled(messages.length, false);
      } else {
        Get.snackbar('Error', 'Failed to fetch messages');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  Future<void> sendMessage() async {

    final accessToken = await AuthService.getAuthorizationToken();
    final userProfile = ConfigPreference.getUserProfile();

    if(selectedImage == null && selectedAudio==null){
      await ApiService.safeApiCall(
        "${AppConstants.url}/messages/send",
        RequestType.post,
        headers: {
          "Authorization": "Bearer $accessToken"
        },
        data: jsonEncode({
          "text": textController.text.isNotEmpty ? textController.text : "",
          "image": null,
          "audio": null,
          "senderId": userProfile['id'],
          "receiverId": receiverData.id,
          "senderUsername": userProfile['userName'],
          "receiverUsername": receiverData.userName
        }),
        onLoading: () {
          update();
        },
        onSuccess: (response) async {
          var responseData = response.data;

          apiCallStatus.value = ApiCallStatus.success;
          textController.clear();
          selectedImage = null;
          selectedAudio = null;
          fetchMessages(receiverData);
          update();
        },
        onError: (error) {
          ApiService.handleApiError(error);
          apiException.value = error;
          apiCallStatus.value = ApiCallStatus.error;
          CustomSnackBar.showCustomErrorToast(
            title: 'Error',
            message: 'Failed to send message $error',
            duration: Duration(seconds: 2),
          );
          fetchMessages(receiverData);
          update();
        },
      );
    }else{
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.url}/messages/send'),
    );

    request.headers['Authorization'] = 'Bearer $accessToken';

    request.fields['senderId'] = userProfile['id'].toString();
    request.fields['receiverId'] = receiverData.id.toString();
    request.fields['senderUsername'] = userProfile['userName'];
    request.fields['receiverUsername'] = receiverData.userName!;
    request.fields['text'] = "null";

    // Handle image attachment
      // Handle image attachment
      if (selectedImage != null) {
        var imageStream = http.ByteStream(selectedImage!.openRead());
        var imageLength = await selectedImage!.length();

        var imageFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: selectedImage!.path.split('/').last,
        );

        request.files.add(imageFile);
      } else {
        request.fields['image'] = "null";
      }

// Handle audio attachment
      if (selectedAudio != null) {
        var audioStream = http.ByteStream(selectedAudio!.openRead());
        var audioLength = await selectedAudio!.length();

        var audioFile = http.MultipartFile(
          'audio',
          audioStream,
          audioLength,
          filename: selectedAudio!.path.split('/').last,
        );

        request.files.add(audioFile);
      } else {
        request.fields['audio'] = "null";
      }


    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        textController.clear();
        selectedImage = null;
        selectedAudio = null;
        fetchMessages(receiverData);
      } else {

      }

      // return http.Response(responseString, response.statusCode);

    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      // return http.Response("Error", 500);
    }
    }
  }

  void imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      sendMessage();
    }
  }

  void imageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      sendMessage();
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
