import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/main_button.dart';
import '../models/invoice.dart';
import '../widgets/invoice_template.dart';
import 'invoice_customize_screen.dart';

class InvoicePreviewScreen extends StatelessWidget {
  const InvoicePreviewScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoicePreviewScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Preview'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                InvoiceTemplate(
                  invoice: invoice,
                  controller: ScreenshotController(),
                ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Customize',
                onPressed: () {
                  context.push(
                    InvoiceCustomizeScreen.routePath,
                    extra: invoice,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
