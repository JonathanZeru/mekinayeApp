import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../model/message.dart';
import '../../util/app_date.dart';
import '../../util/date.dart';
import '../custom_snackbar.dart';

class ChatLeftItem extends StatefulWidget {
  final Message message;

  ChatLeftItem(this.message);

  @override
  _ChatLeftItemState createState() => _ChatLeftItemState();
}

class _ChatLeftItemState extends State<ChatLeftItem> {

  final AudioPlayer advancedPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isAudioComplete = false;

  @override
  void initState() {
    super.initState();
    advancedPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isAudioComplete = true;
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    advancedPlayer.dispose();
    super.dispose();
  }

  Future<void> toggleAudio() async {

    if (isPlaying) {
      await advancedPlayer.pause();
    } else {
      final file = await DefaultCacheManager().getSingleFile(widget.message.audioUrl!);
      await advancedPlayer.setSourceUrl(file.path);
      await advancedPlayer.resume();
    }

    setState(() {
      isPlaying = !isPlaying;
    });
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
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.message.imageUrl != 'null')
                        Container(
                          height: 180,
                          width: 180,
                          child: CachedNetworkImage(
                            imageUrl: widget.message.imageUrl!,
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (widget.message.audioUrl != 'null')
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                onPressed: toggleAudio
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
