import 'dart:io';

import 'package:flutter/material.dart';

import '../utils.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget(
    this.path, {
    this.file = false,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.borderRadius = BorderRadius.zero,
    this.cacheWidth,
    this.cacheHeight,
  });

  final String path;
  final bool file;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry borderRadius;
  final int? cacheWidth;
  final int? cacheHeight;

  Widget errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    logger(error);

    return const SizedBox();
  }

  Widget frameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    return AnimatedOpacity(
      opacity: frame == null ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: file
          ? Image.file(
              File(path),
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            )
          : Image.asset(
              path,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
              cacheWidth: cacheWidth,
              cacheHeight: cacheHeight,
            ),
    );
  }
}
