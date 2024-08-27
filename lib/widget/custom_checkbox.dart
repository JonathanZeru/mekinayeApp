import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final ValueChanged<bool>? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.valueNotifier,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.w,
      child: Checkbox(
        value: valueNotifier.value,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: onChanged != null
            ? (newValue) {
                if (onChanged != null) {
                  onChanged!(newValue ?? false); // Handling null
                  valueNotifier.value = newValue ?? false; // Update value
                }
              }
            : null,
      ),
    );
  }
}
