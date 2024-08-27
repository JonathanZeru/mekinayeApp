import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mekinaye/config/themes/data/app_colors.dart';

import 'button.dart';

class ControllerButtons extends StatelessWidget {
  //Todo migrate to new theme
  final Function() previous;
  final Function() next;
  final bool isLast;
  final bool isFirst;

  const ControllerButtons(
      {super.key,
      required this.previous,
      required this.next,
      required this.isLast,
      required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isFirst
            ? const Spacer()
            : Expanded(
                child: Button(
                    text: "Previous",
                    onPressed: previous,
                    options: ButtonOptions(
                        height: 45.h,
                        padding: const EdgeInsets.all(8),
                        textStyle:
                            const TextStyle(color: AppColors.PRIMARY_COLOR),
                        color: AppColors.whitePlain,
                        borderSide: const BorderSide(
                            color: AppColors.PRIMARY_COLOR, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(8.r))),
                    icon: const Iconify(
                      Mdi.chevron_left,
                      color: AppColors.PRIMARY_COLOR,
                    ))),
        SizedBox(
          width: 25.w,
        ),
        Expanded(child: specialButton())
      ],
    );
  }

  Widget specialButton() {
    return GestureDetector(
      onTap: next,
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: AppColors.PRIMARY_COLOR,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              "Take Quiz",
              style: const TextStyle(color: AppColors.whitePlain),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: 10.w,
            ),
            const Iconify(Mdi.chevron_right, color: AppColors.whitePlain)
          ],
        ),
      ),
    );
  }
}
