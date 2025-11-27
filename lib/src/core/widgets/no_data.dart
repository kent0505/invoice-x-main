import 'package:flutter/material.dart';

import '../constants.dart';
import 'main_button.dart';

class NoData extends StatelessWidget {
  const NoData({
    super.key,
    required this.description,
    required this.buttonTitle,
    this.onPressed,
  });

  final String description;
  final String buttonTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'There is nothing',
              style: TextStyle(
                color: colors.text,
                fontSize: 16,
                fontFamily: AppFonts.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.text2,
                fontSize: 14,
                fontFamily: AppFonts.w400,
              ),
            ),
            const SizedBox(height: 16),
            if (onPressed != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MainButton(
                    title: buttonTitle,
                    onPressed: onPressed!,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
