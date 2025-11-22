import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/my_colors.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/screens/business_screen.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/screens/items_screen.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/models/pro.dart';
import 'currency_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        BlocBuilder<ProBloc, Pro>(
          builder: (context, state) {
            return state.isPro && isIOS()
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SvgWidget(Assets.star),
                          const SizedBox(width: 5),
                          Text(
                            state.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: AppFonts.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Renews on ${state.expireDate}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xff748098),
                          fontSize: 8,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  )
                : const SizedBox();
          },
        ),
        Column(
          children: [
            // _Tile(
            //   title: 'Personal Account',
            //   hasIcon: true,
            //   onPressed: () {},
            // ),
            _Tile(
              title: 'Business Information',
              hasIcon: true,
              onPressed: () {
                context.push(
                  BusinessScreen.routePath,
                  extra: false,
                );
              },
            ),
            _Tile(
              title: 'Clients',
              hasIcon: true,
              onPressed: () {
                context.push(
                  ClientsScreen.routePath,
                  extra: false,
                );
              },
            ),
            _Tile(
              title: 'Items',
              hasIcon: true,
              onPressed: () {
                context.push(
                  ItemsScreen.routePath,
                  extra: false,
                );
              },
            ),
            _Tile(
              title: 'Currency',
              hasIcon: true,
              onPressed: () {
                context.push(CurrencyScreen.routePath);
              },
            ),
            _Tile(
              title: 'Privacy Policy',
              onPressed: () async {
                await launchURL(context, Urls.privacy);
              },
            ),
            _Tile(
              title: 'Terms & Conditions',
              onPressed: () async {
                await launchURL(context, Urls.terms);
              },
            ),
            _Tile(
              title: 'Contact us',
              onPressed: () async {
                await launchURL(context, Urls.contactUs);
              },
            ),
            _Tile(
              title: 'Rate App',
              onPressed: () async {
                // final InAppReview inAppReview = InAppReview.instance;
                // if (await inAppReview.isAvailable()) {
                //   await inAppReview.requestReview();
                // } else {
                //   await inAppReview.openStoreListing();
                // }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    this.hasIcon = false,
    required this.onPressed,
  });

  final String title;
  final bool hasIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Button(
      onPressed: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 44,
        decoration: BoxDecoration(
          color: colors.tertiary1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: AppFonts.w400,
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (hasIcon)
              const RotatedBox(
                quarterTurns: 2,
                child: SvgWidget(Assets.back),
              ),
          ],
        ),
      ),
    );
  }
}
