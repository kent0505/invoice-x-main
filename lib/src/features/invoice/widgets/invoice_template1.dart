import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/image_widget.dart';
import '../../item/models/item.dart';
import '../models/invoice.dart';
import 'template_body.dart';

class InvoiceTemplate1 extends StatelessWidget {
  const InvoiceTemplate1({super.key, required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final type = invoice.isEstimate ? 'ESTIMATE' : 'INVOICE';

    final uniqueInvoiceIDs = <int>{};
    final uniqueItems = <Item>[];
    double subtotal = 0;
    double discount = 0;

    for (final item in invoice.items) {
      subtotal += double.tryParse(item.price) ?? 0;
      discount += double.tryParse(item.discountPrice) ?? 0;
      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }

    final taxPercent = double.tryParse(invoice.tax) ?? 0;
    double taxAmount = discount * (taxPercent / 100);
    double total = discount + taxAmount;

    return TemplateBody(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // image
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  ImageWidget(
                    invoice.business?.imageLogo ?? '',
                    file: true,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$type #${invoice.number}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: AppFonts.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _Data(
                        title: 'Date:  ',
                        data: formatTimestamp2(invoice.date),
                      ),
                      _Data(
                        title: 'Due Date:  ',
                        data: formatTimestamp2(invoice.dueDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // to from
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$type TO:',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: AppFonts.w700,
                        ),
                      ),
                      _Data(
                        title: '',
                        data: invoice.client?.name ?? '',
                      ),
                      _Data(
                        title: 'Address:  ',
                        data: invoice.client?.address ?? '',
                      ),
                      _Data(
                        title: 'Phone:  ',
                        data: invoice.client?.phone ?? '',
                      ),
                      _Data(
                        title: 'Email:  ',
                        data: invoice.client?.email ?? '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$type FROM:',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: AppFonts.w700,
                        ),
                      ),
                      _Data(
                        title: '',
                        data: invoice.business?.name ?? '',
                      ),
                      _Data(
                        title: 'Address:  ',
                        data: invoice.business?.address ?? '',
                      ),
                      _Data(
                        title: 'Phone:  ',
                        data: invoice.business?.phone ?? '',
                      ),
                      _Data(
                        title: 'Email:  ',
                        data: invoice.business?.email ?? '',
                      ),
                      const SizedBox(height: 10),
                      _Data(
                        title: 'Bank:  ',
                        data: invoice.business?.bank ?? '',
                      ),
                      _Data(
                        title: 'Swift:  ',
                        data: invoice.business?.swift ?? '',
                      ),
                      _Data(
                        title: 'IBAN:  ',
                        data: invoice.business?.iban ?? '',
                      ),
                      _Data(
                        title: 'Account No:  ',
                        data: invoice.business?.accountNo ?? '',
                      ),
                      _Data(
                        title: 'VAT:  ',
                        data: invoice.business?.vat ?? '',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),

            // items table
            const SizedBox(height: 10),
            Container(
              height: 20,
              color: const Color(0xff8E8E93).withValues(alpha: 0.2),
              child: const Row(
                children: [
                  Expanded(
                    child: _TableTitle('Name'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('QTY'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('Price'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('Amount'),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(
                uniqueItems.length,
                (index) {
                  int qty = 0;

                  for (final item in invoice.items) {
                    if (item.id == uniqueItems[index].id) {
                      qty++;
                    }
                  }

                  final price =
                      double.tryParse(uniqueItems[index].discountPrice) ?? 0;

                  return Container(
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: const Color(0xff8E8E93).withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TableData(uniqueItems[index].title),
                        ),
                        const _Divider(),
                        SizedBox(
                          width: 80,
                          child: _TableData(qty.toString()),
                        ),
                        const _Divider(),
                        SizedBox(
                          width: 80,
                          child: _TableData(price.toStringAsFixed(2)),
                        ),
                        const _Divider(),
                        SizedBox(
                          width: 80,
                          child: _TableData((price * qty).toStringAsFixed(2)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100 * 2,
                    width: 100 * 3,
                    child: Wrap(
                      children: List.generate(
                        invoice.photos.length,
                        (index) {
                          return ImageWidget(
                            invoice.photos[index].path,
                            file: true,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Data(
                          title: 'Subtotal:  ',
                          data: '\$${subtotal.toStringAsFixed(2)}',
                        ),
                        _Data(
                          title: 'Discount:  ',
                          data: '\$${(subtotal - discount).toStringAsFixed(2)}',
                        ),
                        _Data(
                          title: 'Tax ${invoice.tax}%:  ',
                          data: '\$${(total - discount).toStringAsFixed(2)}',
                        ),
                        _Data(
                          title: 'Total:  ',
                          data: '\$${total.toStringAsFixed(2)}',
                          fontFamily: AppFonts.w600,
                        ),
                        const SizedBox(height: 10),
                        _Data(
                          title: 'Payment method:  ',
                          data: invoice.paymentMethod,
                        ),
                        const SizedBox(height: 10),
                        const Spacer(),
                        Row(
                          children: [
                            const Spacer(),
                            SvgPicture.string(
                              invoice.imageSignature.isEmpty
                                  ? invoice.business?.imageSignature ?? ''
                                  : invoice.imageSignature,
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.title,
    required this.data,
    this.fontFamily = AppFonts.w400,
  });

  final String title;
  final String data;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const SizedBox()
        : Text(
            '$title$data',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontFamily: fontFamily,
              height: 1.1,
            ),
          );
  }
}

class _TableTitle extends StatelessWidget {
  const _TableTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontFamily: AppFonts.w600,
        ),
      ),
    );
  }
}

class _TableData extends StatelessWidget {
  const _TableData(this.data);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        data,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xff8E8E93).withValues(alpha: 0.2),
    );
  }
}
