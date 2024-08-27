import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';
import 'package:mekinaye/widget/button.dart';

class AlertDialogCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final Function() primaryButtonAction;
  final Function()? secondaryButtonAction;

  const AlertDialogCard(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.primaryButtonText,
      this.secondaryButtonText,
      required this.primaryButtonAction,
      this.secondaryButtonAction});

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppTheme.of(context);
    return Container(
      height: 450.h,
      width: 400.w,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            image,
            height: 200.h,
          ),
          Text(
            title,
            textAlign: TextAlign.start,
            style: theme.typography.titleLarge
                .copyWith(fontWeight: FontWeight.bold, color: theme.primary),
          ),
          Text(
            description,
            style: theme.typography.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Button(
                text: primaryButtonText,
                onPressed: primaryButtonAction,
                options: ButtonOptions(
                  height: 45.h,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 10.h),
              if (secondaryButtonText != null && secondaryButtonAction != null)
                Button(
                  text: secondaryButtonText ?? "",
                  onPressed: secondaryButtonAction,
                  options: ButtonOptions(
                      height: 45.h,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      textStyle: theme.typography.bodyMedium
                          .copyWith(color: theme.primary),
                      color: theme.primaryBackground,
                      borderSide: BorderSide(color: theme.primary, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                )
            ],
          )
        ],
      ),
    );
  }
}
