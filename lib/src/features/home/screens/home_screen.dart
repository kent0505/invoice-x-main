import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import '../widgets/nav_bar.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.showPaywall});

  final bool showPaywall;

  static const routePath = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    final index = context.watch<HomeBloc>().state;

    return BlocListener<VipBloc, VipState>(
      listenWhen: (previous, current) {
        return previous.loading && !current.loading;
      },
      listener: (context, state) {
        if (!kDebugMode && showPaywall && !state.loading && !state.isVip) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              if (context.mounted) {
                VipScreen.open(context);
              }
            },
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<InternetBloc, bool>(
          builder: (context, hasConnection) {
            return hasConnection
                ? IndexedStack(
                    index: index,
                    children: const [
                      Center(child: Text('1')),
                      Center(child: Text('2')),
                      Center(child: Text('3')),
                    ],
                  )
                : const NoInternet();
          },
        ),
        bottomNavigationBar: const NavBar(),
      ),
    );
  }
}
