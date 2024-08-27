import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final Color color;
  final double size;
  final String image;
  const SvgIcon({super.key, required this.color, this.size = 35, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
          child: SvgPicture.asset(
            image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
