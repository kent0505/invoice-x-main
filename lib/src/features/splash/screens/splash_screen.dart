import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../client/bloc/client_bloc.dart';
import '../../home/screens/home_screen.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../onboard/data/onboard_repository.dart';
import '../../onboard/screens/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    context.read<InvoiceBloc>().add(GetInvoices());
    context.read<BusinessBloc>().add(GetBusiness());
    context.read<ClientBloc>().add(GetClients());
    context.read<ItemBloc>().add(GetItems());
    // context.read<ProBloc>().add(CheckPro(identifier: Identifiers.paywall1));

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          if (context.read<OnboardRepository>().isOnboard()) {
            context.replace(OnboardScreen.routePath);
          } else {
            context.replace(
              HomeScreen.routePath,
              extra: false,
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Container(
            height: 184,
            width: 184,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xff007144),
            ),
            child: const SvgWidget(Assets.logo),
          ),
        ),
      ),
    );
  }
}
