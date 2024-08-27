import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';

import 'svg_icon.dart';

class StaticCourseContentCard extends StatefulWidget {
  final String text;
  final String image;
  final String voice;

  const StaticCourseContentCard({
    Key? key,
    required this.text,
    required this.image,
    required this.voice, required pronunciation, required symbol,
  }) : super(key: key);

  @override
  State<StaticCourseContentCard> createState() => _StaticCourseContentCardState();
}

class _StaticCourseContentCardState extends State<StaticCourseContentCard> {
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
      setAudio();
    });
    setAudio();
  }

  @override
  void dispose() {
    advancedPlayer.stop();
    advancedPlayer.dispose();
    super.dispose();
  }

  Future<void> setAudio() async {
    final player = AudioCache(prefix: "assets/audio/");
    final url = await player.load(widget.voice);
    //TODO JUST SET THE url to the one coming from backend
    // through the voice variable declared above
    print(url.path);
    advancedPlayer.setSourceUrl(url.path);
    // advancedPlayer.resume();
  }


  double _imageScale = 1.0;

  void toggleAudio() {
    setAudio();
    if (_imageScale == 1.0) {
      setState(() {
        _imageScale = 1.25;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _imageScale = 1.0;
        });
      });
    }
    // Toggle audio playback
    if (isPlaying) {
      advancedPlayer.pause();
    } else {
      advancedPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: theme.accent5.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 40,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: toggleAudio,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 0),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: SvgIcon(
                  image: "assets/icons/speak.svg",
                  color: theme.primaryText,
                  size: 30.sp,
                ),
              ),
              Center(
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    transform: Matrix4.identity()..scale(_imageScale),
                    child: Image.asset(
                        widget.image
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

