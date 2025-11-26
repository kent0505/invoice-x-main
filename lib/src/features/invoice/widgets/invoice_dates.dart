import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/divider_widget.dart';

class InvoiceDates extends StatelessWidget {
  const InvoiceDates({
    super.key,
    required this.date,
    required this.dueDate,
    required this.number,
    required this.onDate,
    required this.onDueDate,
  });

  final int date;
  final int dueDate;
  final int number;
  final VoidCallback onDate;
  final VoidCallback onDueDate;

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
          _Issued(
            date: date,
            onPressed: onDate,
          ),
          const DividerWidget(),
          _Issued(
            date: dueDate,
            onPressed: onDueDate,
          ),
          const DividerWidget(),
          Expanded(
            child: Text(
              formatInvoiceNumber(number),
              textAlign: TextAlign.end,
              style: TextStyle(
                color: colors.text2,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _Issued extends StatelessWidget {
  const _Issued({
    required this.date,
    required this.onPressed,
  });

  final int date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: Button(
        onPressed: onPressed,
        child: SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              date == 0 ? '-' : formatTimestamp(date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.text2,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
