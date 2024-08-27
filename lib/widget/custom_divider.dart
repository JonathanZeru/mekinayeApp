import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double horizontalPadding;

  const CustomDivider({
    Key? key,
    this.horizontalPadding = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Divider(color: theme.primaryColor),
    );
  }
}
