import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../settings/data/settings_repository.dart';
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
    final currency = context.read<SettingsRepository>().getCurrency();

    return Button(
      onPressed: onPressed,
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.5,
              color: Color(0xff7D81A3),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            Text(
              '$currency${item.discountPrice}',
              style: const TextStyle(
                color: Color(0xff7D81A3),
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
