import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import 'button.dart';
import 'svg_widget.dart';

class SheetWidget extends StatelessWidget {
  const SheetWidget({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SheetWidget(
          title: title,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 36,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: colors.tertiary3,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              SheetTitle(title: title),
              const Spacer(),
              Button(
                onPressed: () {
                  context.pop();
                },
                child: SvgWidget(
                  Assets.close,
                  color: colors.text2,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class SheetTitle extends StatelessWidget {
  const SheetTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Text(
      title,
      style: TextStyle(
        color: colors.text,
        fontSize: 18,
        fontFamily: AppFonts.w600,
      ),
    );
  }
}
