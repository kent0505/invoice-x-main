import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: colors.bg,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: colors.tertiary1,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgWidget(
                    Assets.internet,
                    color: colors.error,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'You’re offline',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontFamily: AppFonts.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'No internet connection found. Check your connection and try again',
                style: TextStyle(
                  color: colors.text2,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: MainButton(
                  title: 'Retry',
                  width: Constants.mainButtonWidth,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
