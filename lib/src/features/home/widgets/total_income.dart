import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../profile/data/profile_repository.dart';

class TotalIncome extends StatelessWidget {
  const TotalIncome({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    final currency = context.read<ProfileRepository>().getCurrency();

    return Column(
      children: [
        Text(
          'Total Income',
          style: TextStyle(
            color: colors.text,
            fontSize: 16,
            fontFamily: AppFonts.w500,
          ),
        ),
        const SizedBox(height: 4),
        BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoaded) {
              final sorted = state.invoices.where((element) {
                return element.paymentMethod.isNotEmpty;
              }).toList();

              return BlocBuilder<ItemBloc, ItemState>(
                builder: (context, state) {
                  double total = 0;

                  final items = state.items;

                  for (final invoice in sorted) {
                    double invoiceSubtotal = 0;

                    for (final item in items) {
                      if (item.invoiceID == invoice.id) {
                        invoiceSubtotal +=
                            double.tryParse(item.discountPrice) ?? 0;
                      }
                    }

                    final taxPercent = double.tryParse(invoice.tax) ?? 0;
                    final taxAmount = invoiceSubtotal * (taxPercent / 100);
                    final invoiceTotal = invoiceSubtotal + taxAmount;
                    total += invoiceTotal;
                  }

                  return Text(
                    '$currency${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 32,
                      fontFamily: AppFonts.w700,
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
