import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    this.suffixIcon,
    this.onTap,
    this.prefixIcon,
    this.validator,
    this.focusNode,
    this.errorMsg,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: 340.w,
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTap: onTap,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration:
           InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 8.sp)),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(5.r),
            //   borderSide:
            //       BorderSide(color: Theme.of(context).colorScheme.onSecondary),
            // ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, 
              fontSize: 20.sp,
              fontWeight: FontWeight.w300,
            
            ),
            labelStyle: Theme.of(context).textTheme.labelSmall,
            errorText: errorMsg,
          ),
        ),
      ),
    );
  }
}

