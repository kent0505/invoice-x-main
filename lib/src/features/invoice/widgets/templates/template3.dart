import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../core/utils.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../item/models/item.dart';
import '../../../signature/widgets/signature_widget.dart';
import '../../models/invoice.dart';
import '../template_body.dart';

class Template3 extends StatelessWidget {
  const Template3({
    super.key,
    required this.invoice,
    required this.color,
  });

  final Invoice invoice;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const type = 'INVOICE';

    final uniqueInvoiceIDs = <String>{};
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$type #${invoice.number}',
                        style: TextStyle(
                          color: color,
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
                  const Spacer(),
                  ImageWidget(
                    invoice.business?.image ?? '',
                    file: true,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            // to from

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Billing to:',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
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
                        'Billing from:',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
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
            const SizedBox(height: 9),
            Container(
              height: 20,
              color: color,
              child: const Row(
                children: [
                  Expanded(
                    child: _TableTitle('Name'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('Price'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('Quantity'),
                  ),
                  SizedBox(
                    width: 80,
                    child: _TableTitle('Total'),
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

                  final price = getItemPrice(uniqueItems[index]);

                  final color = index % 2 == 0 ? null : const Color(0xffEBEBEB);

                  return Container(
                    height: 20,
                    decoration: BoxDecoration(color: color),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TableData(uniqueItems[index].title),
                        ),
                        SizedBox(
                          width: 80,
                          child: _TableData('\$${price.toStringAsFixed(2)}'),
                        ),
                        SizedBox(
                          width: 80,
                          child: _TableData(qty.toString()),
                        ),
                        SizedBox(
                          width: 80,
                          child: _TableData(
                              '\$${(price * qty).toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 110 * 2,
                    width: 110 * 3,
                    child: Wrap(
                      children: List.generate(
                        invoice.photos.length,
                        (index) {
                          return ImageWidget(
                            invoice.photos[index].path,
                            file: true,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _Data(
                            title: 'Subtotal:  ',
                            data: '\$${subtotal.toStringAsFixed(2)}',
                          ),
                          _Data(
                            title: 'Discount:  ',
                            data:
                                '\$${(subtotal - discount).toStringAsFixed(2)}',
                          ),
                          _Data(
                            title: 'Tax ${invoice.tax}%:  ',
                            data: '\$${(total - discount).toStringAsFixed(2)}',
                          ),
                          Container(
                            color: color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            child: _Data(
                              title: 'Total:  ',
                              data: '\$${total.toStringAsFixed(2)}',
                              fontFamily: AppFonts.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _Data(
                            title: 'Payment method:  ',
                            data: invoice.paymentMethod,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      const Spacer(),
                      SignatureWidget(
                        string: invoice.signature.isEmpty
                            ? invoice.business?.signature ?? ''
                            : invoice.signature,
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
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.title,
    required this.data,
    this.fontFamily = AppFonts.w400,
    this.color = Colors.black,
  });

  final String title;
  final String data;
  final String fontFamily;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const SizedBox()
        : Text(
            '$title$data',
            style: TextStyle(
              color: color,
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
          color: Colors.white,
          fontSize: 8,
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
          fontSize: 8,
          fontFamily: AppFonts.w400,
        ),
      ),
    );
  }
}
