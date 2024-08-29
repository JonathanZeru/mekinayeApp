import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../layout/message/full_image_screen.dart';
import '../../model/message.dart';
import '../../util/app_date.dart';
import '../../util/date.dart';

class ChatRightItem extends StatefulWidget {
  final Message message;

  ChatRightItem(this.message);

  @override
  _ChatRightItemState createState() => _ChatRightItemState();
}

class _ChatRightItemState extends State<ChatRightItem> {
  late AudioPlayer player;
  bool isPlaying = false;
  Duration? _duration;
  Duration? _position;
  PlayerState? _playerState;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    player.onPlayerComplete.listen((_) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await player.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _stop() async {
    if(isPlaying){
      await player.stop();
      setState(() {
        _position = Duration.zero;
        isPlaying = false;
      });
    }
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 200,
                  minHeight: 40,
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                    onPressed: () async {
                                      if (isPlaying) {
                                        await _pause();
                                      } else {
                                        if (widget.message.audioUrl != 'null') {
                                          final file = await DefaultCacheManager().getSingleFile(widget.message.audioUrl!);
                                          await player.setSourceUrl(file.path);
                                          await _play();
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.stop),
                                    onPressed:isPlaying ? () async {
                                      await _stop();
                                    } : null
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
                                  player.seek(Duration(milliseconds: position.round()));
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
          padding: EdgeInsets.only(right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
