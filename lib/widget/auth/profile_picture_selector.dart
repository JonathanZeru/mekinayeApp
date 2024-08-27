import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/generated/assets.dart';
import 'package:mekinaye/widget/cached_image.dart';

class ProfilePictureSelector extends StatelessWidget {
  final File imageFile;
  final String imageUrl;
  final VoidCallback onClicked;
  final bool isFile;
  final bool hasImage;

  const ProfilePictureSelector({
    Key? key,
    required this.imageFile,
    required this.imageUrl,
    required this.onClicked,
    required this.isFile,
    required this.hasImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              ClipOval(
                child: Material(
                  color: theme.accent1.withOpacity(0.2),
                  child: Ink(
                    width: 90.w,
                    height: 90.h,
                    child: InkWell(
                      onTap: onClicked,
                      child: hasImage
                          ? (isFile
                              ? Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                )
                              : imageUrl != "null"
                                  ? CachedImage(
                                      url: imageUrl,
                                      fit: BoxFit.cover,
                                      size: 100.sp,
                                    )
                                  : Icon(
                                      CupertinoIcons.camera,
                                      size: 50.sp,
                                    ))
                          : Icon(
                              CupertinoIcons.camera,
                              size: 50.sp,
                            ),
                    ),
                  ),
                ),
              ),
              if (hasImage)
                Positioned(
                  bottom: -1,
                  right: -5,
                  child: Ink(
                    child: InkWell(
                      onTap: onClicked,
                      child: Image.asset(
                        Assets.iconsAdd,
                        width: 25.w,
                        height: 25.h,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
