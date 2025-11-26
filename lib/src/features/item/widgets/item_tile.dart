import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../profile/data/profile_repository.dart';
import '../models/item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.onPressed,
  });

  final Item item;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    final currency = context.read<ProfileRepository>().getCurrency();

    return Button(
      onPressed: onPressed,
      child: Container(
        height: 72,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.tertiary1,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontFamily: AppFonts.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$currency${item.discountPrice.isEmpty ? item.price : item.discountPrice}',
                    style: TextStyle(
                      color: colors.text2,
                      fontSize: 14,
                      fontFamily: AppFonts.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            RotatedBox(
              quarterTurns: 2,
              child: SvgWidget(
                Assets.back,
                color: colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
