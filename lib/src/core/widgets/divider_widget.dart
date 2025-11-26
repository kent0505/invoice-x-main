import 'package:flutter/material.dart';

import '../constants.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 14,
      width: 1,
      decoration: BoxDecoration(
        color: colors.tertiary3,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
