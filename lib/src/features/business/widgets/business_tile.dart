import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../models/business.dart';

class BusinessTile extends StatelessWidget {
  const BusinessTile({
    super.key,
    required this.business,
    required this.onPressed,
  });

  final Business business;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.tertiary1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Button(
        onPressed: onPressed,
        child: Row(
          children: [
            business.imageLogo.isEmpty
                ? Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: colors.tertiary4,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgWidget(
                        Assets.person,
                        height: 24,
                        color: colors.accent,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.file(
                      File(business.imageLogo),
                      frameBuilder: ImageWidget.frameBuilder,
                      errorBuilder: ImageWidget.errorBuilder,
                      height: 44,
                      width: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
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
                    business.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
