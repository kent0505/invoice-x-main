import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({
    super.key,
    required this.title,
    this.right,
  });

  final String title;
  final Widget? right;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: colors.text,
          fontSize: 32,
          fontFamily: AppFonts.w700,
        ),
      ),
      centerTitle: false,
      actions: [right ?? const SizedBox()],
    );
  }
}
