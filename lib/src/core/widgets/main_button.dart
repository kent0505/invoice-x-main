import 'package:flutter/material.dart';

import '../constants.dart';
import 'button.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.title,
    this.width,
    this.horizontal = 0,
    this.color,
    this.active = true,
    required this.onPressed,
  });

  final String title;
  final double? width;
  final double horizontal;
  final Color? color;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: Constants.milliseconds),
      height: 58,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: horizontal),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color ?? (active ? colors.accent : colors.tertiary2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Button(
        onPressed: active ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color == null ? colors.bg : colors.text,
                fontSize: 16,
                fontFamily: AppFonts.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainButtonWrapper extends StatelessWidget {
  const MainButtonWrapper({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      color: colors.bg,
      padding: const EdgeInsets.all(16).copyWith(
        bottom: 16 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
