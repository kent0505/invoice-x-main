import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../client/screens/clients_list.dart';
import '../../internet/bloc/internet_bloc.dart';
import '../../internet/widgets/no_internet_dialog.dart';
import '../../invoice/screens/invoices_tab.dart';
import '../../profile/screens/profile_tab.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/screens/vip_screen.dart';
import '../widgets/home_appbar.dart';
import '../widgets/nav_bar.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.showPaywall});

  final bool showPaywall;

  static const routePath = '/HomeScreen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

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
        appBar: HomeAppbar(
          title: switch (index) {
            0 => 'Invoices',
            1 => 'Clients',
            2 => 'Profile',
            _ => '',
          },
          right: index == 0
              ? Button(
                  onPressed: () {},
                  child: SvgWidget(
                    Assets.search,
                    color: colors.text2,
                  ),
                )
              : null,
        ),
        body: BlocConsumer<InternetBloc, bool>(
          listener: (context, hasConnection) {
            if (!hasConnection) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return const NoInternetDialog();
                },
              );
            }
          },
          builder: (context, hasConnection) {
            return IndexedStack(
              index: index,
              children: const [
                InvoicesTab(),
                ClientsList(),
                ProfileTab(),
              ],
            );
          },
        ),
        bottomNavigationBar: const NavBar(),
      ),
    );
  }
}
