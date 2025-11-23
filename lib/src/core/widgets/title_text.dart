import 'package:flutter/material.dart';

import '../constants.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.title,
    this.additional = '',
    this.left = 0,
  });

  final String title;
  final String additional;
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
        spacing: 4,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 12,
              fontFamily: AppFonts.w500,
            ),
          ),
          Text(
            additional,
            style: TextStyle(
              color: colors.text2,
              fontSize: 12,
              fontFamily: AppFonts.w400,
            ),
          ),
        ],
      ),
    );
  }
}
