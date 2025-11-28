import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../../item/models/item.dart';
import '../../profile/data/profile_repository.dart';
import '../models/invoice.dart';
import '../models/template_data.dart';
import 'templates/template1.dart';
import 'templates/template2.dart';
import 'templates/template3.dart';
import 'templates/template4.dart';
import 'templates/template5.dart';
import 'templates/template6.dart';

class InvoiceTemplate extends StatelessWidget {
  const InvoiceTemplate({
    super.key,
    required this.invoice,
    required this.controller,
  });

  final Invoice invoice;
  final ScreenshotController controller;

  @override
  Widget build(BuildContext context) {
    final type = invoice.photos.isEmpty ? 'INVOICE' : 'ESTIMATE';

    final currency = context.read<ProfileRepository>().getCurrency();

    final uniqueInvoiceIDs = <String>{};
    final uniqueItems = <Item>[];

    double subtotal = 0;
    double discount = 0;
    double taxableBase = 0;

    for (final item in invoice.items) {
      final original = double.tryParse(item.price) ?? 0;
      final percent = double.tryParse(item.discount) ?? 0;

      final itemDiscount = original * (percent / 100);
      final finalPrice = original - itemDiscount;

      subtotal += original;
      discount += itemDiscount;
      taxableBase += finalPrice;

      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }

    final taxPercent = double.tryParse(invoice.tax) ?? 0;
    final taxAmount = taxableBase * (taxPercent / 100);
    final total = taxableBase + taxAmount;

    final data = TemplateData(
      type: type,
      currency: currency,
      subtotal: subtotal,
      discount: discount,
      tax: taxAmount,
      total: total,
      uniqueItems: uniqueItems,
    );

    return FittedBox(
      child: Screenshot(
        controller: controller,
        child: switch (invoice.template) {
          1 => Template1(
              invoice: invoice,
              data: data,
            ),
          2 => Template2(
              invoice: invoice,
              data: data,
            ),
          3 => Template3(
              invoice: invoice,
              data: data,
              color: const Color(0xff1455CD),
            ),
          4 => Template3(
              invoice: invoice,
              data: data,
              color: const Color(0xff004C08),
            ),
          5 => Template3(
              invoice: invoice,
              data: data,
              color: const Color(0xff4C0001),
            ),
          6 => Template4(
              invoice: invoice,
              data: data,
            ),
          7 => Template5(
              invoice: invoice,
              data: data,
            ),
          8 => Template6(
              invoice: invoice,
              data: data,
              color: const Color(0xff241E63),
              textColor: Colors.white,
            ),
          9 => Template6(
              invoice: invoice,
              data: data,
              color: const Color(0xffEAE728),
              textColor: Colors.black,
            ),
          10 => Template6(
              invoice: invoice,
              data: data,
              color: const Color(0xffFF6464),
              textColor: Colors.white,
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}
