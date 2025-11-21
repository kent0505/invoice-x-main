import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/my_colors.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: colors.tertiary2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: colors.tertiary3,
                ),
              ),
              child: Center(
                child: SvgWidget(
                  Assets.internet,
                  color: colors.text2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You’re currently offline!',
              style: TextStyle(
                color: colors.text,
                fontSize: 16,
                fontFamily: AppFonts.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your network connection and try again. Restart the app or check your internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.text2,
                fontSize: 14,
                fontFamily: AppFonts.w500,
              ),
            ),
            const SizedBox(height: 8),
            MainButton(
              title: 'Retry',
              width: Constants.mainButtonWidth,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
