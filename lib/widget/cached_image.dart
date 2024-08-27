import 'package:flutter/material.dart';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';

import 'package:mekinaye/generated/assets.dart';

class CachedImage extends StatelessWidget {
  final double size;
  final String url;
  final BoxFit fit;

  const CachedImage(
      {super.key, required this.url, required this.fit, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FastCachedImage(
        //works with webp
        url: url,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 250),
        errorBuilder: (context, exception, stacktrace) {
          return Container(
            color: Colors.transparent,
            child: Image.asset(Assets.imagesLogo),
          );
        },
        loadingBuilder: (context, progress) {
          return Container(
            color: Colors.transparent,
          );
        },
      ),
    );
  }
}
