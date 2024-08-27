import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

import '../config/themes/data/app_theme.dart';

import 'custom_input_field.dart';



class CustomSnackBarInputField {

  static acceptVerificationCode(
      String title,
      String hint,
      String errorMessage,
  String confirmBtnText,
  String cancelBtnText,
  Function()? onConfirmBtn,
  Function()? onCancelBtn,
  TextEditingController textController,
      AppTheme theme,
      Iconify icon
      ) {
    Get.defaultDialog(
      title: title,
      content: CustomInputField(
        textEditingController: textController,
        hint: hint,
        obscureText: false,
        type: TextInputType.text,
        textStyle: theme.typography.bodySmall,
        labelTextStyle: theme.typography.labelMedium,
        isDense: true,
        prefixIcon: icon,
        validator: (value) {
          if (value!.isEmpty) {
            return errorMessage;
          }
          return null;
        },
      ),
      actions: [
        TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent),

          ),
          onPressed: onCancelBtn,
          child: Text(cancelBtnText, style: theme.typography.labelSmall),
        ),
        TextButton(
          onPressed: onConfirmBtn,
          child: Text(confirmBtnText, style: theme.typography.labelSmall.copyWith(
              color: Colors.white
          )),
        )
      ],
    );
  }
}