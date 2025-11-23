import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import 'business_info_screen.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  static const String routePath = '/OnboardScreen';

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int index = 0;

  final pageController = PageController();

  void onPageChanged(int value) {
    setState(() {
      index = value;
    });
  }

  void onContinue() async {
    if (index == 2) {
      context.replace(BusinessInfoScreen.routePath);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        index++;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      backgroundColor: colors.tertiary4,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgWidget(Assets.onb1),
                ),
                Stack(
                  children: [
                    Positioned(
                      top: -10,
                      left: 0,
                      right: 0,
                      child: ImageWidget(Assets.onb2),
                    ),
                  ],
                ),
                SvgWidget(Assets.onb3),
              ],
            ),
          ),
          Container(
            height: 310,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      dotColor: colors.tertiary4,
                      activeDotColor: colors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  switch (index) {
                    0 => 'Create Invoices in Seconds',
                    1 => 'Instant Invoice File Sharing',
                    2 => 'Rate us to improve app',
                    int() => '',
                  },
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 32,
                    fontFamily: AppFonts.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  switch (index) {
                    0 =>
                      'Generate professional invoices quickly and customize them to fit your brand.',
                    1 =>
                      'Send invoices or PDF files to clients with just one tap — via email, AirDrop, or any app you prefer.',
                    2 =>
                      'We value ideas and feedback. Your input helps us improve the app',
                    int() => '',
                  },
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text2,
                    fontSize: 14,
                    fontFamily: AppFonts.w400,
                  ),
                ),
                const Spacer(),
                MainButton(
                  title: 'Continue',
                  onPressed: onContinue,
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
