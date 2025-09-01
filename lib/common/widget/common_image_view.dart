import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum ImageSource { asset, file, network }

class CommonImageView extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final ImageSource source;
  final Widget? placeholder;

  const CommonImageView({
    Key? key,
    required this.imagePath,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
  }) : super(key: key);

  bool get _isSvg => imagePath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    switch (source) {
      case ImageSource.asset:
        return _isSvg
            ? SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          color: color,
          placeholderBuilder: (_) =>
          placeholder ?? const Center(child: CircularProgressIndicator()),
        )
            : Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          color: color,
        );

      case ImageSource.file:
        return Image.file(
          File(imagePath),
          width: width,
          height: height,
          fit: fit,
          color: color,
        );

      case ImageSource.network:
        return _isSvg
            ? SvgPicture.network(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          color: color,
          placeholderBuilder: (_) =>
          placeholder ?? const Center(child: CircularProgressIndicator()),
        )
            : CachedNetworkImage(
          imageUrl: imagePath,
          width: width,
          height: height,
          fit: fit,
          color: color,
          placeholder: (_, __) =>
          placeholder ?? const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
        );
    }
  }
}