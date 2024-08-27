import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/generated/assets.dart';

class LabeledHeader extends StatelessWidget {
  final String? pictureLabel;
  final String? picture;
  final String pageLabel;

  const LabeledHeader({
    Key? key,
    this.pictureLabel,
    this.picture,
    required this.pageLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.only(top: 60.h, bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            picture ?? Assets.imagesLogoWithLabel,
            height: 150.h,
            width: 200.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          if (pictureLabel != null)
            Text(
              pictureLabel!,
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
          if (pictureLabel != null) SizedBox(height: 20.h),
          Text(
            pageLabel,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold
            )
          ),
        ],
      ),
    );
  }
}
