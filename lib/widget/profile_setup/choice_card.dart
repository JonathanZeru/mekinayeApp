import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';


class ChoiceCard extends StatelessWidget {
  final bool isLevel;
  final String title;
  final String subtitle;
  final String image;
  final bool selected;

  const ChoiceCard(
      {super.key,
      required this.isLevel,
      required this.title,
      required this.subtitle,
      required this.image,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: selected ?  theme.accent3 : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          width: 0.5,
          color: selected ? theme.primary.withOpacity(0.9) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            // This will be the same for both dark and light
            spreadRadius: 1,
            blurRadius: 30,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              image,
              height: isLevel ? 25.sp : 50.sp,
              width: isLevel ? 25.sp :  50.sp,
            ),
          ),
          SizedBox(
            width: 75.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: theme.typography.titleSmall
                        .copyWith(fontWeight: FontWeight.w600)),
                if (isLevel) const SizedBox(height: 8.0),
                if (isLevel)
                  Text(
                    subtitle,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
