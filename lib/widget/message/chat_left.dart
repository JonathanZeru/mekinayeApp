import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../layout/message/full_image_screen.dart';
import '../../model/message.dart';
import '../../util/app_date.dart';
import '../../util/date.dart';

class ChatLeftItem extends StatefulWidget {
  final Message message;

  ChatLeftItem(this.message);

  @override
  _ChatLeftItemState createState() => _ChatLeftItemState();
}

class _ChatLeftItemState extends State<ChatLeftItem> {
  late AudioPlayer advancedPlayer;
  bool isPlaying = false;
  Duration? _duration;
  Duration? _position;
  PlayerState? _playerState;

  @override
  void initState() {
    super.initState();
    advancedPlayer = AudioPlayer();
    advancedPlayer.setReleaseMode(ReleaseMode.stop);

    advancedPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    advancedPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    advancedPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
        isPlaying = state == PlayerState.playing;
      });
    });

    advancedPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    advancedPlayer.dispose();
    super.dispose();
  }

  Future<void> toggleAudio() async {
    if (isPlaying) {
      await advancedPlayer.pause();
    } else {
      if (widget.message.audioUrl != 'null') {
        final file = await DefaultCacheManager().getSingleFile(widget.message.audioUrl!);
        await advancedPlayer.setSourceUrl(file.path);
        await advancedPlayer.resume();
      }
    }
  }

  Future<void> _stop() async {
    await advancedPlayer.stop();
    setState(() {
      _position = Duration.zero;
      isPlaying = false;
    });
  }

  Future<void> _downloadAndSaveAudio() async {
    if (widget.message.audioUrl != 'null') {
      try {
        final dio = Dio();
        final directory = await getExternalStorageDirectory(); // For scoped storage
        final downloadDirectory = Directory('${directory?.parent.path}/Download');
        if (!await downloadDirectory.exists()) {
          await downloadDirectory.create(recursive: true);
        }
        final filePath = '${downloadDirectory.path}/${widget.message.audioUrl!.split('/').last}';
        await dio.download(
          widget.message.audioUrl!,
          filePath,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: Duration(seconds: 0)
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio downloaded successfully to $filePath',
            style: TextStyle(color: Colors.black),
          )),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e',
            style: TextStyle(color: Colors.black),)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 200,
                  minHeight: 40,
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.message.imageUrl != 'null')
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  imageUrl: widget.message.imageUrl!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 180,
                            width: 180,
                            child: CachedNetworkImage(
                              imageUrl: widget.message.imageUrl!,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (widget.message.audioUrl != 'null')
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                    onPressed: toggleAudio,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.stop),
                                    onPressed: isPlaying ? _stop : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: _downloadAndSaveAudio,
                                  ),
                                ],
                              ),
                              Slider(
                                onChanged: (value) {
                                  if (_duration == null) return;
                                  final position = value * _duration!.inMilliseconds;
                                  advancedPlayer.seek(Duration(milliseconds: position.round()));
                                },
                                value: (_position != null &&
                                    _duration != null &&
                                    _position!.inMilliseconds > 0 &&
                                    _position!.inMilliseconds < _duration!.inMilliseconds)
                                    ? _position!.inMilliseconds / _duration!.inMilliseconds
                                    : 0.0,
                              ),
                              Text(
                                _position != null
                                    ? '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}'
                                    : _duration != null
                                    ? _duration.toString().split('.').first
                                    : '',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      if (widget.message.text != 'null')
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            widget.message.text!,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Text(
                duTimeLineFormat(widget.message.createdAt!),
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
