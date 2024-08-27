import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';

Widget leadingIcon(BuildContext context) {
  final AppTheme theme = AppTheme.of(context);
  return Padding(
    padding: EdgeInsets.all(10.r),
    child: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: CircleAvatar(
        backgroundColor: theme.alternate,
        radius: 20.r,
        child: Align(
            alignment: Alignment.center,
            child: Iconify(
              MaterialSymbols.chevron_left_rounded,
              size: 33.r,
            )),
      ),
    ),
  );
}
