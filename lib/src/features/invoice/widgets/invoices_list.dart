import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/no_data.dart';
import '../../item/bloc/item_bloc.dart';
import '../../profile/data/profile_repository.dart';
import '../models/invoice.dart';
import '../screens/invoice_details_screen.dart';

class InvoicesList extends StatelessWidget {
  const InvoicesList({super.key, required this.invoices});

  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
    return invoices.isEmpty
        ? const NoData(
            description:
                'You haven’t created any invoices yet. Tap the button below to create your first one.',
            buttonTitle: 'Create invoice',
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];

              return _InvoiceTile(invoice: invoice);
            },
          );
  }
}

class _InvoiceTile extends StatelessWidget {
  const _InvoiceTile({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    final paid = invoice.paymentMethod.isNotEmpty;

    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.tertiary1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Button(
        onPressed: () {
          context.push(
            InvoiceDetailsScreen.routePath,
            extra: invoice,
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${formatInvoiceNumber(invoice.number)} Invoice',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontFamily: AppFonts.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: paid ? colors.accent : colors.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          paid ? 'Paid' : 'Unpaid',
                          style: TextStyle(
                            color: colors.bg,
                            fontSize: 12,
                            fontFamily: AppFonts.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatTimestamp(invoice.date),
                        style: TextStyle(
                          color: colors.text2,
                          fontSize: 14,
                          fontFamily: AppFonts.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  final currency =
                      context.read<ProfileRepository>().getCurrency();

                  final items = state.items.where((item) {
                    return item.iid == invoice.id;
                  });

                  double amount = 0;

                  for (final item in items) {
                    amount += getItemPrice(item);
                  }

                  return Text(
                    '$currency$amount',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontFamily: AppFonts.w600,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
