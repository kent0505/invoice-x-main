import 'package:flutter/material.dart';

import '../constants.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.title,
    this.left = 0,
  });

  final String title;
  final double left;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        left: left,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 12,
              fontFamily: AppFonts.w500,
            ),
          ),
        ],
      ),
    );
  }
}
