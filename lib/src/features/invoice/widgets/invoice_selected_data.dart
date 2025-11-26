import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';

class InvoiceSelectedData extends StatelessWidget {
  const InvoiceSelectedData({
    super.key,
    required this.title,
    this.amount = 1,
    required this.onPressed,
  });

  final String title;
  final int amount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colors.tertiary1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          ),
          if (amount > 1)
            Text(
              'x$amount',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: AppFonts.w600,
              ),
            ),
          const SizedBox(width: 16),
          Button(
            onPressed: onPressed,
            child: SvgWidget(
              Assets.close,
              color: colors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
