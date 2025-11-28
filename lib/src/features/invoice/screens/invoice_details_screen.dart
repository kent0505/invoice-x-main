import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/sheet_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../business/bloc/business_bloc.dart';
import '../../client/bloc/client_bloc.dart';
import '../../item/bloc/item_bloc.dart';
import '../widgets/invoice_template.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import 'edit_invoice_screen.dart';
import 'invoice_customize_screen.dart';

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

  void onCustomize() {
    context.pop();
    context.push(
      InvoiceCustomizeScreen.routePath,
      extra: invoice,
    );
  }

  void onEdit() {
    context.pop();
    context.push(
      EditInvoiceScreen.routePath,
      extra: invoice,
    );
  }

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete invoice?',
      delete: true,
      onPressed: () {
        context.read<InvoiceBloc>().add(DeleteInvoice(invoice: invoice));
        context.read<ItemBloc>().add(ReplaceItems(iid: invoice.id));
        context.pop();
        context.pop();
        context.pop();
      },
    );
  }

  void onShare() async {
    await captureWidget();
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          sharePositionOrigin: const Rect.fromLTWH(100, 100, 200, 200),
        ),
      );
    } catch (e) {
      logger(e);
    }
  }

  void onPaid() {}

  @override
  void initState() {
    super.initState();
    invoice = widget.invoice;
    invoice.business = context
        .read<BusinessBloc>()
        .state
        .businesses
        .firstWhereOrNull((element) => element.id == invoice.bid);
    invoice.client = context
        .read<ClientBloc>()
        .state
        .clients
        .firstWhereOrNull((element) => element.id == invoice.cid);
    invoice.items = context
        .read<ItemBloc>()
        .state
        .items
        .where((element) => element.iid == invoice.id)
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
          onPressed: () {
            SheetWidget.show(
              context: context,
              title: 'Select option',
              isScrollControlled: false,
              expanded: false,
              child: SizedBox(
                child: MainButtonWrapper(
                  children: [
                    MainButton(
                      title: 'Customize',
                      color: colors.bg,
                      buttonColor: colors.text,
                      onPressed: onCustomize,
                    ),
                    MainButton(
                      title: 'Edit',
                      color: colors.bg,
                      buttonColor: colors.text,
                      onPressed: onEdit,
                    ),
                    MainButton(
                      title: 'Delete',
                      color: colors.bg,
                      buttonColor: colors.error,
                      onPressed: onDelete,
                    ),
                    MainButton(
                      title: 'Cancel',
                      color: colors.bg,
                      buttonColor: colors.text,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: const SvgWidget(Assets.menu),
        ),
        child: _AppbarChild(invoice: invoice),
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
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    return InvoiceTemplate(
                      invoice: invoice,
                      controller: screenshotController,
                    );
                  },
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
  const _AppbarChild({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('#${formatInvoiceNumber(invoice.number)}'),
        const SizedBox(width: 8),
        Button(
          onPressed: () {
            SheetWidget.show(
              context: context,
              title: 'Select option',
              expanded: false,
              isScrollControlled: false,
              child: Column(
                children: [
                  _PayTile(
                    invoice: invoice,
                    paymentMethod: '',
                    title: 'Unpaid',
                  ),
                  _PayTile(
                    invoice: invoice,
                    paymentMethod: 'Cash',
                    title: 'Cash',
                  ),
                  _PayTile(
                    invoice: invoice,
                    paymentMethod: 'Check',
                    title: 'Check',
                  ),
                  _PayTile(
                    invoice: invoice,
                    paymentMethod: 'Bank',
                    title: 'Bank',
                  ),
                  _PayTile(
                    invoice: invoice,
                    paymentMethod: 'PayPal',
                    title: 'PayPal',
                  ),
                ],
              ),
            );
          },
          child: BlocBuilder<InvoiceBloc, InvoiceState>(
            builder: (context, state) {
              bool paid = invoice.paymentMethod.isNotEmpty;

              return Container(
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
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PayTile extends StatelessWidget {
  const _PayTile({
    required this.invoice,
    required this.paymentMethod,
    required this.title,
  });

  final Invoice invoice;
  final String paymentMethod;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(bottom: 8),
      child: Button(
        onPressed: () {
          invoice.paymentMethod = paymentMethod;
          invoice.paymentDate = DateTime.now().millisecondsSinceEpoch;
          context.read<InvoiceBloc>().add(EditInvoice(invoice: invoice));
          context.pop();
        },
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.text,
                fontSize: 16,
                fontFamily: AppFonts.w500,
              ),
            ),
            const Spacer(),
            if (invoice.paymentMethod == paymentMethod)
              SvgWidget(
                Assets.checked,
                color: colors.accent,
              ),
          ],
        ),
      ),
    );
  }
}
