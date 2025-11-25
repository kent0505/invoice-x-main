import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../../home/widgets/total_income.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../../../core/widgets/tab_widget.dart';
import 'edit_invoice_screen.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoaded) {
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
                if (invoices.isNotEmpty)
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
        }

        return const SizedBox();
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
        ? NoData(
            description:
                'You haven’t created any invoices yet. Tap the button below to create your first one.',
            buttonTitle: 'Create invoice',
            onPressed: () {
              context.push(
                EditInvoiceScreen.routePath,
                extra: null,
              );
            },
          )
        : ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];

              return Container(
                height: 72,
                decoration: BoxDecoration(
                  color: colors.tertiary1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            invoice.number.toString(),
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 16,
                              fontFamily: AppFonts.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.accent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Unpaid',
                                  style: TextStyle(
                                    color: colors.bg,
                                    fontSize: 12,
                                    fontFamily: AppFonts.w400,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                invoice.date.toString(),
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
              );
            },
          );
  }
}
