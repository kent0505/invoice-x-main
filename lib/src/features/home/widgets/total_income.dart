import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../invoice/bloc/invoice_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../profile/data/profile_repository.dart';

class TotalIncome extends StatelessWidget {
  const TotalIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ).copyWith(top: 16 + MediaQuery.of(context).viewPadding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Income',
                  style: TextStyle(
                    color: Color(0xff8E8E93),
                    fontSize: 14,
                  ),
                ),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    if (state is InvoiceLoaded) {
                      final currency =
                          context.read<ProfileRepository>().getCurrency();

                      final sorted = state.invoices.where((element) {
                        return element.paymentMethod.isNotEmpty;
                      }).toList();

                      return BlocBuilder<ItemBloc, List<Item>>(
                        builder: (context, items) {
                          double total = 0;

                          for (final invoice in sorted) {
                            double invoiceSubtotal = 0;

                            for (final item in items) {
                              if (item.invoiceID == invoice.id) {
                                invoiceSubtotal +=
                                    double.tryParse(item.discountPrice) ?? 0;
                              }
                            }

                            final taxPercent =
                                double.tryParse(invoice.tax) ?? 0;
                            final taxAmount =
                                invoiceSubtotal * (taxPercent / 100);
                            final invoiceTotal = invoiceSubtotal + taxAmount;
                            total += invoiceTotal;
                          }

                          return Text(
                            '$currency${total.toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: AppFonts.w800,
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
