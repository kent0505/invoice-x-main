import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../client/bloc/client_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../widgets/invoice_template.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import 'edit_invoice_screen.dart';

class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/InvoiceDetailsScreen';

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  final screenshotController = ScreenshotController();

  late Invoice invoice;

  File file = File('');

  Future<pw.Document> captureWidget() async {
    final pdf = pw.Document();
    final bytes = await screenshotController.capture();
    if (bytes != null) {
      final dir = await getTemporaryDirectory();
      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(bytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );
      file = File('${dir.path}/invoice_${invoice.number}.pdf');
      await file.writeAsBytes(await pdf.save());
    }
    return pdf;
  }

  void onPrint() async {
    final pdf = await captureWidget();
    Printing.layoutPdf(
      format: PdfPageFormat.a4,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void onEdit() {
    context.push<Invoice>(EditInvoiceScreen.routePath, extra: invoice).then(
      (value) {
        if (value != null) {
          setState(() {
            invoice = value;
          });
        }
      },
    );
  }

  void onShare() async {
    await captureWidget();
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        sharePositionOrigin: const Rect.fromLTWH(100, 100, 200, 200),
      ),
    );
  }

  void onPaid() {}

  void onMenu() {}

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    invoice.business = context
        .read<BusinessBloc>()
        .state
        .businesses
        .firstWhereOrNull((element) => element.id == widget.invoice.bid);
    invoice.client = context
        .read<ClientBloc>()
        .state
        .clients
        .firstWhereOrNull((element) => element.id == widget.invoice.cid);
    invoice.items = context
        .read<ItemBloc>()
        .state
        .items
        .where((element) => element.iid == widget.invoice.id)
        .toList();
    invoice.photos = context
        .read<InvoiceBloc>()
        .state
        .photos
        .where((photo) => photo.id == invoice.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        right: Button(
          onPressed: onMenu,
          child: const SvgWidget(Assets.menu),
        ),
        child: _AppbarChild(
          invoice: invoice,
          onPressed: onPaid,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 44,
                vertical: 16,
              ),
              children: [
                InvoiceTemplate(
                  invoice: invoice,
                  controller: screenshotController,
                ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Print',
                color: colors.bg,
                onPressed: onPrint,
              ),
              MainButton(
                title: 'Share Invoice',
                onPressed: onShare,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppbarChild extends StatelessWidget {
  const _AppbarChild({
    required this.invoice,
    required this.onPressed,
  });

  final Invoice invoice;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    bool paid = invoice.paymentMethod.isNotEmpty;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('#${formatInvoiceNumber(invoice.number)}'),
        const SizedBox(width: 8),
        Button(
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: paid ? colors.accent : colors.error,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 20,
            child: Row(
              children: [
                Text(
                  paid ? 'Paid' : 'Unpaid',
                  style: TextStyle(
                    color: colors.bg,
                    fontSize: 12,
                    fontFamily: AppFonts.w400,
                  ),
                ),
                const SizedBox(width: 2),
                RotatedBox(
                  quarterTurns: 3,
                  child: SvgWidget(
                    Assets.back,
                    color: colors.bg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
