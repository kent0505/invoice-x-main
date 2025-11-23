import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/sheet_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/bloc/business_bloc.dart';
import '../../client/screens/clients_tab.dart';
import '../../item/widgets/items_list.dart';
import '../widgets/currency_list.dart';

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
            SheetWidget.show(
              context: context,
              title: 'Business',
              child: ListView(
                children: const [],
              ),
            );
          },
        ),
        _Tile(
          title: 'Clients',
          hasIcon: true,
          onPressed: () {
            SheetWidget.show(
              context: context,
              title: 'Clients',
              child: const ClientsTab(),
            );
          },
        ),
        _Tile(
          title: 'Items',
          hasIcon: true,
          onPressed: () {
            SheetWidget.show(
              context: context,
              title: 'Items',
              child: const ItemsList(),
            );
          },
        ),
        _Tile(
          title: 'Currency',
          hasIcon: true,
          onPressed: () {
            SheetWidget.show(
              context: context,
              title: 'Currency',
              child: const CurrencyList(),
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

    return BlocBuilder<BusinessBloc, BusinessState>(
      builder: (context, state) {
        final isNull = state.defaultBusiness == null;

        final imageLogo = isNull ? '' : state.defaultBusiness!.imageLogo;

        final name = isNull ? 'Account Name' : state.defaultBusiness!.name;

        return Column(
          children: [
            isNull
                ? Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: colors.tertiary4,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: SvgWidget(Assets.person),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(164),
                    child: Image.file(
                      File(imageLogo),
                      errorBuilder: ImageWidget.errorBuilder,
                      frameBuilder: ImageWidget.frameBuilder,
                      height: 88,
                      width: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: colors.text,
                fontSize: 20,
                fontFamily: AppFonts.w600,
              ),
            ),
          ],
        );
      },
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