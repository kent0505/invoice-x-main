import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/button.dart';
import '../bloc/home_bloc.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      height: Constants.navBarHeight + bottom,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: colors.tertiary1,
        border: Border(
          top: BorderSide(
            width: 1,
            color: colors.tertiary1,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavBarButton(
            index: 0,
            title: 'Invoices',
            asset: Assets.tab1,
          ),
          _NavBarButton(
            index: 1,
            title: 'Clients',
            asset: Assets.tab2,
          ),
          _NavBarButton(
            index: 2,
            title: 'Profile',
            asset: Assets.tab3,
          ),
        ],
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.index,
    required this.asset,
    required this.title,
  });

  final int index;
  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Expanded(
      child: SizedBox(
        height: 44,
        child: BlocBuilder<HomeBloc, int>(
          builder: (context, state) {
            final active = state == index;

            return Button(
              onPressed: active
                  ? null
                  : () {
                      context.read<HomeBloc>().add(ChangePage(index: index));
                    },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgWidget(
                    asset,
                    height: 24,
                    color: active ? colors.accent : colors.text2,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: active ? colors.accent : colors.text2,
                      fontSize: 12,
                      fontFamily: active ? AppFonts.w500 : AppFonts.w400,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
