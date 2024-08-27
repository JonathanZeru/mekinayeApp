import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/themes/data/app_theme.dart';
import '../button.dart';

class ErrorCard extends StatelessWidget {
  final String image;
  final String title;
  final String body;
  final VoidCallback? refresh;

  const ErrorCard(
      {super.key,
      this.refresh,
      required this.image,
      required this.title,
      required this.body});

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(image, height: 300.h),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.typography.titleMedium
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 30.w),
          child: Text(body,
              textAlign: TextAlign.center,
              style: theme.typography.bodyMedium
                  .copyWith(fontWeight: FontWeight.w400)),
        ),
        const Spacer(),
        buildButton(),
        const Spacer(),
      ],
    );
  }

  Widget buildButton() {
    if (refresh == null) {
      return const SizedBox.shrink();
    }
    return Button(
      text: "Refresh",
      onPressed: refresh!,
      options: ButtonOptions(width: 300.w, height: 45.h),
    );
  }
}
