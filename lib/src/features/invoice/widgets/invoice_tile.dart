import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../client/bloc/client_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../profile/data/profile_repository.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../screens/invoice_details_screen.dart';

class InvoiceTile extends StatelessWidget {
  const InvoiceTile({
    super.key,
    required this.invoice,
    required this.circleColor,
  });

  final Invoice invoice;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    final client = context.watch<ClientBloc>().state.firstWhereOrNull(
      (element) {
        return element.id == invoice.clientID;
      },
    );

    final currency = context.read<ProfileRepository>().getCurrency();

    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: 107 / MediaQuery.of(context).size.width,
        motion: const ScrollMotion(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 6,
              bottom: 6,
              right: 16,
            ),
            child: Builder(builder: (ctx) {
              return Button(
                onPressed: () {
                  DialogWidget.show(
                    context,
                    title: 'Delete?',
                    delete: true,
                    onPressed: () {
                      Slidable.of(ctx)?.close();
                      context
                          .read<InvoiceBloc>()
                          .add(DeleteInvoice(invoice: invoice));
                      context.pop();
                    },
                  );
                },
                child: Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: SvgWidget(Assets.delete),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      child: Container(
        height: 85,
        margin: const EdgeInsets.only(
          bottom: 6,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
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
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<BusinessBloc, List<Business>>(
                  builder: (context, state) {
                    final business = state.firstWhereOrNull((element) {
                      return element.id == invoice.businessID;
                    });

                    return business == null
                        ? Text(
                            client?.name[0] ?? '?',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: AppFonts.w600,
                            ),
                          )
                        : ImageWidget(
                            business.imageLogo,
                            file: true,
                            height: 28 * 2,
                            width: 28 * 2,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(28),
                          );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client?.name ?? '?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    BlocBuilder<ItemBloc, List<Item>>(
                      builder: (context, items) {
                        double subtotal = 0;

                        for (final item in items) {
                          if (item.invoiceID == invoice.id) {
                            subtotal +=
                                double.tryParse(item.discountPrice) ?? 0;
                          }
                        }

                        final taxPercent = double.tryParse(invoice.tax) ?? 0;
                        final taxAmount = subtotal * (taxPercent / 100);
                        final total = subtotal + taxAmount;

                        return Text(
                          invoice.paymentMethod.isEmpty
                              ? invoice.isEstimate
                                  ? 'Estimate Send'
                                  : 'Invoice Send'
                              : 'Received $currency${total.toStringAsFixed(2)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: AppFonts.w400,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Builder(builder: (context) {
                final date = DateTime.fromMillisecondsSinceEpoch(invoice.date);
                final now = DateTime.now();
                final isToday = date.year == now.year &&
                    date.month == now.month &&
                    date.day == now.day;
                if (isToday) {
                  'Today';
                } else {
                  DateFormat('MMM d. yyyy').format(date);
                }

                return Text(
                  isToday ? 'Today' : DateFormat('MMM d. yyyy').format(date),
                  style: const TextStyle(
                    color: Color(0xff748098),
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                );
              }),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
