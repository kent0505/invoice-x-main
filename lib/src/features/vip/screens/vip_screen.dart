import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/vip_bloc.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  static const routePath = '/VipScreen';

  static Future<void> configure(String userID) async {
    if (isIOS()) {
      await Purchases.configure(
        PurchasesConfiguration('appl_XOzrSgcIeAVfozHHQbvIJjGyatM')
          ..appUserID = userID,
      );
    }
  }

  static void open(BuildContext context) {
    // final state = context.read<VipBloc>().state;
    // if (!state.loading && !state.isVip) {
    context.push(VipScreen.routePath);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<VipBloc, VipState>(
        builder: (context, state) {
          if (state.loading) {
            return const LoadingWidget();
          }

          if (state.offering == null) {
            return NoData(
              description: 'Offering not found',
              buttonTitle: 'Back',
              onPressed: () {
                context.pop();
              },
            );
          }

          return PaywallView(
            offering: state.offering,
            onDismiss: () {
              context.pop();
            },
            onPurchaseCompleted: (customerInfo, storeTransaction) {
              context
                  .read<VipBloc>()
                  .add(CheckPurchased(customerInfo: customerInfo));
              context.pop();
            },
            onRestoreCompleted: (customerInfo) {
              context
                  .read<VipBloc>()
                  .add(CheckPurchased(customerInfo: customerInfo));
              context.pop();
            },
            onPurchaseCancelled: () {
              context.pop();
            },
            onPurchaseError: (e) {
              context.pop();
              DialogWidget.show(
                context,
                title: e.message,
              );
            },
            onRestoreError: (e) {
              context.pop();
              DialogWidget.show(
                context,
                title: e.message,
              );
            },
          );
        },
      ),
    );
  }
}
