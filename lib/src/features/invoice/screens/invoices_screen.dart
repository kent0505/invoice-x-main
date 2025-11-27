import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_app/src/features/invoice/screens/invoice_details_screen.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../../core/widgets/tab_widget.dart';
import '../../home/widgets/total_income.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import 'edit_invoice_screen.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        final invoices = state.invoices;

        final unpaidInvoices = invoices.where((invoice) {
          return invoice.paymentMethod.isEmpty;
        }).toList();

        final paidInvoices = invoices.where((invoice) {
          return invoice.paymentMethod.isNotEmpty;
        }).toList();

        return NestedScrollView(
          headerSliverBuilder: (_, __) => [
            if (invoices.isNotEmpty)
              const SliverAppBar(
                expandedHeight: 76,
                flexibleSpace: FlexibleSpaceBar(
                  background: TotalIncome(),
                ),
              ),
          ],
          body: Stack(
            children: [
              TabWidget(
                titles: const ['All', 'Unpaid', 'Paid'],
                pages: [
                  _Sorted(invoices: invoices),
                  _Sorted(invoices: unpaidInvoices),
                  _Sorted(invoices: paidInvoices),
                ],
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: MainButton(
                  title: 'Create invoice',
                  onPressed: () {
                    context.push(
                      EditInvoiceScreen.routePath,
                      extra: null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sorted extends StatelessWidget {
  const _Sorted({required this.invoices});

  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

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
                      // EditInvoiceScreen.routePath,
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
                        child: Text(
                          '1.860.56 USD',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 20,
                            fontFamily: AppFonts.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
