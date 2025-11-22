import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/sheet_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/screens/business_screen.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/screens/items_screen.dart';
import 'currency_sheet.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _Account(),
        const SizedBox(height: 16),
        const TitleText(title: 'Account data'),
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
            SheetWidget.show(
              context: context,
              child: const CurrencySheet(),
            );
          },
        ),
        const SizedBox(height: 8),
        const TitleText(title: 'Settings'),
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
    );
  }
}

class _Account extends StatelessWidget {
  const _Account();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Column(
      children: [
        Container(
          height: 88,
          width: 88,
          decoration: BoxDecoration(
            color: colors.tertiary4,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: SvgWidget(Assets.person),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Account Name',
          style: TextStyle(
            color: colors.text,
            fontSize: 20,
            fontFamily: AppFonts.w600,
          ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 44,
      decoration: BoxDecoration(
        color: colors.tertiary1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Button(
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontFamily: AppFonts.w500,
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

        // BlocBuilder<ProBloc, Pro>(
        //   builder: (context, state) {
        //     return state.isPro && isIOS()
        //         ? Column(
        //             children: [
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   const SvgWidget(Assets.star),
        //                   const SizedBox(width: 5),
        //                   Text(
        //                     state.title,
        //                     textAlign: TextAlign.center,
        //                     style: const TextStyle(
        //                       color: Colors.black,
        //                       fontSize: 10,
        //                       fontFamily: AppFonts.w600,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //               const SizedBox(height: 4),
        //               Text(
        //                 'Renews on ${state.expireDate}',
        //                 textAlign: TextAlign.center,
        //                 style: const TextStyle(
        //                   color: Color(0xff748098),
        //                   fontSize: 8,
        //                   fontFamily: AppFonts.w400,
        //                 ),
        //               ),
        //               const SizedBox(height: 14),
        //             ],
        //           )
        //         : const SizedBox();
        //   },
        // ),