import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignatureWidget extends StatelessWidget {
  const SignatureWidget({
    super.key,
    required this.string,
    this.height,
    this.width,
  });

  final String string;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return string.isEmpty
        ? const SizedBox()
        : SizedBox(
            height: height,
            width: width,
            child: FittedBox(
              child: SvgPicture.string(
                string,
                height: height,
                width: width,
              ),
            ),
          );
  }
}
