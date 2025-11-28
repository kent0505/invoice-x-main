import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../models/invoice.dart';
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
    return FittedBox(
      child: Screenshot(
        controller: controller,
        child: switch (invoice.template) {
          1 => Template1(invoice: invoice),
          2 => Template2(invoice: invoice),
          3 => Template3(
              invoice: invoice,
              color: const Color(0xff1455CD),
            ),
          4 => Template3(
              invoice: invoice,
              color: const Color(0xff004C08),
            ),
          5 => Template3(
              invoice: invoice,
              color: const Color(0xff4C0001),
            ),
          6 => Template4(invoice: invoice),
          7 => Template5(invoice: invoice),
          8 => Template6(
              invoice: invoice,
              color: const Color(0xff241E63),
              textColor: Colors.white,
            ),
          9 => Template6(
              invoice: invoice,
              color: const Color(0xffEAE728),
              textColor: Colors.black,
            ),
          10 => Template6(
              invoice: invoice,
              color: const Color(0xffFF6464),
              textColor: Colors.white,
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}
