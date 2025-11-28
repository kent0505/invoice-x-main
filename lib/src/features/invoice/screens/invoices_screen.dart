import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/tab_widget.dart';
import '../bloc/invoice_bloc.dart';
import '../widgets/invoices_list.dart';
import '../widgets/total_income.dart';
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
                  InvoicesList(invoices: invoices),
                  InvoicesList(invoices: unpaidInvoices),
                  InvoicesList(invoices: paidInvoices),
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
