import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import 'main_button.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.title,
    this.delete = false,
    this.onPressed,
  });

  final String title;
  final bool delete;
  final VoidCallback? onPressed;

  static void show(
    BuildContext context, {
    required String title,
    bool delete = false,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      useSafeArea: false,
      builder: (context) {
        return DialogWidget(
          title: title,
          delete: delete,
          onPressed: onPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Dialog(
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontFamily: AppFonts.w500,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (delete) ...[
                    Expanded(
                      child: MainButton(
                        title: 'Cancel',
                        color: colors.bg,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: MainButton(
                        title: 'Yes',
                        onPressed: onPressed ??
                            () {
                              context.pop();
                            },
                      ),
                    ),
                  ] else
                    MainButton(
                      title: 'OK',
                      onPressed: onPressed ??
                          () {
                            context.pop();
                          },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
