import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import 'invoice_template1.dart';
import 'invoice_template2.dart';
import 'invoice_template3.dart';
import 'invoice_template4.dart';
import 'invoice_template5.dart';
import 'invoice_template6.dart';

class InvoiceTemplate extends StatefulWidget {
  const InvoiceTemplate({
    super.key,
    required this.invoice,
    required this.controller,
  });

  final Invoice invoice;
  final ScreenshotController controller;

  @override
  State<InvoiceTemplate> createState() => _InvoiceTemplateState();
}

class _InvoiceTemplateState extends State<InvoiceTemplate> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Screenshot(
        controller: widget.controller,
        child: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            if (state is InvoiceLoaded) {
              return switch (widget.invoice.template) {
                1 => InvoiceTemplate1(invoice: widget.invoice),
                2 => InvoiceTemplate2(invoice: widget.invoice),
                3 => InvoiceTemplate3(
                    invoice: widget.invoice,
                    color: const Color(0xff1455CD),
                  ),
                4 => InvoiceTemplate3(
                    invoice: widget.invoice,
                    color: const Color(0xff004C08),
                  ),
                5 => InvoiceTemplate3(
                    invoice: widget.invoice,
                    color: const Color(0xff4C0001),
                  ),
                6 => InvoiceTemplate4(invoice: widget.invoice),
                7 => InvoiceTemplate5(invoice: widget.invoice),
                8 => InvoiceTemplate6(
                    invoice: widget.invoice,
                    color: const Color(0xff241E63),
                    textColor: Colors.white,
                  ),
                9 => InvoiceTemplate6(
                    invoice: widget.invoice,
                    color: const Color(0xffEAE728),
                    textColor: Colors.black,
                  ),
                10 => InvoiceTemplate6(
                    invoice: widget.invoice,
                    color: const Color(0xffFF6464),
                    textColor: Colors.white,
                  ),
                _ => const SizedBox(),
              };
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
