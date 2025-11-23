import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/no_data.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../widgets/tab_widget.dart';
import 'create_invoice_screen.dart';

class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        if (state is InvoiceLoaded) {
          final sorted = state.invoices;

          return Stack(
            children: [
              TabWidget(
                titles: const ['All', 'Unpaid', 'Paid'],
                pages: [
                  _InvoicesList(invoices: sorted),
                  _InvoicesList(invoices: sorted),
                  _InvoicesList(invoices: sorted),
                ],
              ),
              if (sorted.isNotEmpty)
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: MainButton(
                    title: 'Create invoice',
                    onPressed: () {
                      context.push(CreateInvoiceScreen.routePath);
                    },
                  ),
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _InvoicesList extends StatelessWidget {
  const _InvoicesList({required this.invoices});

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
              context.push(CreateInvoiceScreen.routePath);
            },
          )
        : ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
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
                            invoices[index].number.toString(),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
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
                                invoices[index].date.toString(),
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
