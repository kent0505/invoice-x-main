import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/vip_bloc.dart';

class VipWidget extends StatelessWidget {
  const VipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return BlocBuilder<VipBloc, VipState>(
      builder: (context, state) {
        return state.isVip
            ? const SizedBox()
            : Container(
                height: 20,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SvgWidget(Assets.premium),
                    const SizedBox(width: 2),
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: colors.tertiary1,
                        fontSize: 12,
                        fontFamily: AppFonts.w400,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
