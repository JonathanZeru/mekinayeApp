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
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

import '../../util/app_constants.dart';
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

  late Record audioRecord;
  late AudioPlayer audioPlayer;
  RxBool isRecording = false.obs;
  // RxBool recodingNow = true.obs;
  String audioPath = "";
  RxBool playing = false.obs;
  RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    userId.value = ConfigPreference.getUserProfile()['id'].toString();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
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
        fetchMessages(receiverData);
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
    audioRecord.dispose();
    audioPlayer.dispose();
    stopMessagePolling();
    super.onClose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        isRecording.value = true;
      }
    } catch (e, stackTrace) {
      print("START RECORDING ERROR: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      // recodingNow.value = false;
      isRecording.value = false;
      audioPath = path ?? "";
    } catch (e) {
      print("STOP RECORDING ERROR: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      playing.value = true;
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.completed) {
          playing.value = false;
        }
      });
    } catch (e) {
      print("PLAY RECORDING ERROR: $e");
    }
  }

  Future<void> pauseRecording() async {
    try {
      playing.value = false;
      await audioPlayer.pause();
    } catch (e) {
      print("PAUSE RECORDING ERROR: $e");
    }
  }

  RxDouble uploadProgress = 0.0.obs;
  Future<void> uploadAndDeleteRecording() async {
    isSending.value = true;
    final userProfile = ConfigPreference.getUserProfile();
    try {
      final url = Uri.parse('${AppConstants.url}/messages/send');
      final file = File(audioPath);
      if (!file.existsSync()) {
        print("UPLOAD FILE NOT EXIST");
        return;
      }

      final fileName = file.path.split('/').last;

      final request = http.MultipartRequest('POST', url)
        ..files.add(
          http.MultipartFile(
            'audio',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: fileName,
          ),
        )
        ..fields['senderId'] = userProfile['id'].toString()
        ..fields['receiverId'] = receiverData.id.toString()
        ..fields['senderUsername'] = userProfile['userName']
        ..fields['receiverUsername'] = receiverData.userName!
        ..fields['text'] = "null"
        ..fields['image'] = "null";

      final streamedResponse = await http.Client().send(request);

      int totalBytes = file.lengthSync();
      int bytesUploaded = 0;

      streamedResponse.stream.transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          bytesUploaded += data.length;
          double progress = bytesUploaded / totalBytes;
          uploadProgress.value = progress;
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) {
          print('UPLOAD ERROR: $error');
          sink.addError(error, stackTrace);
        },
        handleDone: (sink) async {
          sink.close();
        },
      )).listen((_) {});

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {

      } else {
        print('UPLOAD FAILED. STATUS CODE: ${response.statusCode}');
      }
      isSending.value = false;
      uploadProgress.value = 1.0; // Set progress to 100% on success
      audioPath = "";
      playing.value = false;
      // recodingNow.value = true; // Reset to initial recording state
      deleteRecording();
      update();
    } catch (e) {
      print('UPLOAD ERROR: $e');
    }
  }

  Future<void> deleteRecording() async {
    if (audioPath.isNotEmpty) {
      try {
        File file = File(audioPath);
        if (file.existsSync()) {
          file.deleteSync();
          print("FILE DELETED");
        }
      } catch (e) {
        print("FILE DELETE ERROR: $e");
      }
      audioPath = "";
    }
  }

  void setReceiverData(UserModel receiverDataModel) {
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
        print("FAILED TO LOAD USER DATA");
      }
    } catch (e) {
      print("FETCH USER DATA ERROR: $e");
    }
  }

  void fetchMessages(UserModel owner) async {
    checkConnection();
    receiverData = owner;
    Map<String, dynamic> userProfile = ConfigPreference.getUserProfile();

    try {
      final response = await http.get(
        Uri.parse('${AppConstants.url}/messages/get-both-chats?senderId=${userProfile['id']}&receiverId=${receiverData.id}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        messages.value = data.map((item) => Message.fromJson(item)).toList().reversed.toList();
      } else {
        print("FAILED TO FETCH MESSAGES");
      }
    } catch (e) {
      print("FETCH MESSAGES ERROR: $e");
    }
  }
  Future<void> sendMessage(bool isAudio) async {

    // final accessToken = await AuthService.getAuthorizationToken();
    final userProfile = ConfigPreference.getUserProfile();
    if(isAudio){
      uploadAndDeleteRecording();
    }else {
      if (selectedImage == null && selectedAudio == null) {
        await ApiService.safeApiCall(
          "${AppConstants.url}/messages/send",
          RequestType.post,
          // headers: {
          //   "Authorization": "Bearer $accessToken"
          // },
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
            textController.text = "";
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
            textController.text = "";
            selectedImage = null;
            selectedAudio = null;
            fetchMessages(receiverData);
            update();
          },
        );
        textController.text = "";
      }
      else {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AppConstants.url}/messages/send'),
        );

        // request.headers['Authorization'] = 'Bearer $accessToken';

        request.fields['senderId'] = userProfile['id'].toString();
        request.fields['receiverId'] = receiverData.id.toString();
        request.fields['senderUsername'] = userProfile['userName'];
        request.fields['receiverUsername'] = receiverData.userName!;
        request.fields['text'] = "null";
        request.fields['audio'] = "null";
        // Handle image attachment
        // Handle image attachment
        if (selectedImage != null) {
          var imageStream = http.ByteStream(selectedImage!.openRead());
          var imageLength = await selectedImage!.length();

          var imageFile = http.MultipartFile(
            'image',
            imageStream,
            imageLength,
            filename: selectedImage!
                .path
                .split('/')
                .last,
          );

          request.files.add(imageFile);
        } else {
          request.fields['image'] = "null";
        }


        try {
          var response = await request.send();
          var responseString = await response.stream.bytesToString();

          if (response.statusCode == 201) {
            textController.text = "";
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

