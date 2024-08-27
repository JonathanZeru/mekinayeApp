import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

import 'package:mekinaye/config/themes/data/app_theme.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final String? Function(String? val) validator;
  final String? Function(String? val)? onChanged;
  final void Function()? onTap;
  bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? label;
  final bool passwordInput;
  final String? hint;
  final int? maxLength;
  final TextInputType? type;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final EdgeInsets? padding;
  final bool? isDense;
  final bool? enabled;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  CustomInputField({
    super.key,
    required this.textEditingController,
    required this.obscureText,
    required this.validator,
    this.label,
    this.passwordInput = false,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.hint,
    this.maxLength,
    this.type,
    this.textStyle,
    this.labelTextStyle,
    this.padding,
    this.isDense,
    this.onTap,
    this.enabled,
    this.maxLines,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    if (widget.passwordInput) {
      return Padding(
        padding:
            widget.padding ?? EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16.h),
        child: SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: widget.textEditingController,
            focusNode: widget.focusNode,
            autofocus: false,
            maxLines: widget.maxLines ?? 1,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            keyboardType: widget.type,
            autofillHints: const [AutofillHints.password],
            obscureText: !widget.obscureText,
            enabled: widget.enabled ?? true,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              isDense: widget.isDense,
              labelText: widget.label,
              hintText: widget.hint,
              labelStyle: widget.labelTextStyle ?? theme.typography.labelLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primary.withOpacity(0.25),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              filled: true,
              fillColor: theme.secondaryBackground,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                child: Iconify(Mdi.password_outline,
                    size: 20.sp, color: theme.primaryText.withOpacity(0.50)),
              ),
              suffixIcon: InkWell(
                  onTap: () => setState(
                        () => widget.obscureText = !widget.obscureText,
                      ),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Padding(
                      padding:
                          EdgeInsets.only(top: 12.h, bottom: 12.h, right: 20.w),
                      child: Iconify(
                          widget.obscureText
                              ? Mdi
                                  .visibility_outline //Todo use material Symbols icon
                              : Mdi.visibility_off_outline,
                          size: 20.sp,
                          color: theme.primaryText.withOpacity(0.50)))),
            ),
            style: widget.textStyle ?? theme.typography.bodyLarge,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onTap: widget.onTap,
          ),
        ),
      );
    } else {
      return Padding(
        padding:
            widget.padding ?? EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16.h),
        child: SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: widget.textEditingController,
            focusNode: widget.focusNode,
            autofocus: false,
            maxLength: widget.maxLength,
            onChanged: widget.onChanged,
            autofillHints: const [AutofillHints.password],
            keyboardType: widget.type,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              isDense: widget.isDense,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      child: widget.prefixIcon)
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 15.w),
                      child: widget.suffixIcon)
                  : null,
              labelText: widget.label,
              hintText: widget.hint,
              labelStyle: widget.labelTextStyle ?? theme.typography.labelLarge,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primary.withOpacity(0.25),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.error,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              filled: true,
              fillColor: theme.secondaryBackground,
            ),
            style: widget.textStyle ?? theme.typography.bodyLarge,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onTap: widget.onTap,
          ),
        ),
      );
    }
  }
}
