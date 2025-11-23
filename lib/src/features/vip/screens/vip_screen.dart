import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../bloc/vip_bloc.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  static const routePath = '/VipScreen';

  static void configure(String userID) async {
    await Purchases.configure(
      PurchasesConfiguration('appl_XOzrSgcIeAVfozHHQbvIJjGyatM')
        ..appUserID = userID,
    );
  }

  static void open(BuildContext context) {
    context.push(VipScreen.routePath);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      body: BlocConsumer<VipBloc, VipState>(
        listener: (context, state) {
          if (state.offering == null && !state.loading) {
            context.pop();
          }
        },
        builder: (context, state) {
          if (state.loading || state.offering == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Offering not found',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontFamily: AppFonts.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MainButton(
                    title: 'Back',
                    width: Constants.mainButtonWidth,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            );
          }

          return PaywallView(
            offering: state.offering,
            onDismiss: () {
              context.pop();
            },
            onPurchaseCompleted: (customerInfo, storeTransaction) {
              context.pop();
            },
            onRestoreCompleted: (customerInfo) {
              context.pop();
            },
            onPurchaseCancelled: () {
              context.pop();
              DialogWidget.show(
                context,
                title: 'Purchase Cancelled',
              );
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
