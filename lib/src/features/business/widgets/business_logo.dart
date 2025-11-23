import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';

class BusinessLogo extends StatelessWidget {
  const BusinessLogo({
    super.key,
    required this.imageLogo,
    required this.onPressed,
  });

  final String imageLogo;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Center(
      child: Button(
        onPressed: onPressed,
        child: SizedBox(
          width: 164,
          height: 164,
          child: imageLogo.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(164),
                  child: Image.file(
                    File(imageLogo),
                    errorBuilder: ImageWidget.errorBuilder,
                    frameBuilder: ImageWidget.frameBuilder,
                    height: 164,
                    width: 164,
                    fit: BoxFit.cover,
                  ),
                )
              : DottedBorder(
                  options: CircularDottedBorderOptions(
                    strokeWidth: 6,
                    dashPattern: [21, 21],
                    color: colors.tertiary3,
                  ),
                  child: Center(
                    child: SvgWidget(
                      Assets.add,
                      height: 60,
                      color: colors.accent,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
