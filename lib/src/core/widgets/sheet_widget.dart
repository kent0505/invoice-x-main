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
    this.expanded = true,
  });

  final String title;
  final Widget child;
  final bool expanded;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    bool isScrollControlled = true,
    bool expanded = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      builder: (context) {
        return SheetWidget(
          title: title,
          expanded: expanded,
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
        mainAxisSize: MainAxisSize.min,
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
              Text(
                title,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 18,
                  fontFamily: AppFonts.w600,
                ),
              ),
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
          expanded ? Expanded(child: child) : child,
        ],
      ),
    );
  }
}
