import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:mekinaye/config/themes/data/app_theme.dart';

class CustomDropDown extends StatelessWidget {
  final String? value;
  final String? hint;
  final List<String> options;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final TextStyle? textStyle;
  final void Function(String?) onChanged;
  final String? Function(String?) validator;
  final EdgeInsets? padding;
  final double? height;

  const CustomDropDown({
    super.key,
    required this.value,
    required this.options,
    this.hint,
    this.labelText,
    required this.onChanged,
    required this.validator,
    this.padding,
    this.textStyle,
    this.labelTextStyle,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelTextStyle ?? theme.typography.labelLarge,
        contentPadding: padding ?? EdgeInsets.symmetric(vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        focusColor: theme.primary,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.radius),
          borderSide: BorderSide(
            color: theme.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.primary.withOpacity(0.25),
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
      hint: Text(
        hint!,
        style: textStyle ?? theme.typography.labelLarge.copyWith(
            color: theme.primaryText.withOpacity(0.7)
        ),
      ),
      items: options
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: textStyle ?? theme.typography.bodyLarge,
                ),
              ))
          .toList(),
      validator: (value) {
        return validator(value);
      },
      onChanged: onChanged,
      onSaved: (value) {
        value = value.toString();
      },
      value: value,
      buttonStyleData: ButtonStyleData(
        height: height,
        padding: EdgeInsets.only(right: 8.w),
      ),
      iconStyleData: IconStyleData(
        icon: Iconify(
          Mdi.chevron_down,
          size: 25.sp,
          color: theme.primaryText,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 0.5.sh,
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(theme.radius),
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
    );
  }
}
