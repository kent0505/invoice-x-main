import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import '../../item/widgets/item_field.dart';
import '../../settings/data/settings_repository.dart';
import '../bloc/invoice_bloc.dart';
import 'photos_list.dart';
import '../models/photo.dart';
import 'invoice_dates.dart';
import 'invoice_select_data.dart';
import 'invoice_selected_data.dart';

class InvoiceBody extends StatelessWidget {
  const InvoiceBody({
    super.key,
    required this.isEstimate,
    required this.active,
    required this.date,
    required this.dueDate,
    required this.onDate,
    required this.onDueDate,
    required this.number,
    required this.business,
    required this.onSelectBusiness,
    required this.client,
    required this.onSelectClient,
    required this.items,
    required this.onSelectItems,
    required this.onRemoveItem,
    required this.hasSignature,
    required this.signature,
    required this.onSignature,
    required this.onAddSignature,
    required this.photos,
    required this.onAddPhotos,
    required this.onCreate,
    required this.isTaxable,
    required this.onTaxable,
    required this.taxController,
    required this.checkActive,
  });

  final bool isEstimate;
  final bool active;

  final int date;
  final int dueDate;
  final VoidCallback onDate;
  final VoidCallback onDueDate;

  final int number;

  final Business? business;
  final VoidCallback onSelectBusiness;

  final Client? client;
  final VoidCallback onSelectClient;

  final List<Item> items;
  final VoidCallback onSelectItems;
  final void Function(Item) onRemoveItem;

  final bool hasSignature;
  final String signature;
  final VoidCallback onSignature;
  final VoidCallback onAddSignature;

  final List<Photo> photos;
  final VoidCallback onAddPhotos;

  final VoidCallback onCreate;

  final bool isTaxable;
  final VoidCallback onTaxable;
  final TextEditingController taxController;
  final void Function(String) checkActive;

  @override
  Widget build(BuildContext context) {
    final currency = context.read<SettingsRepository>().getCurrency();
    final uniqueInvoiceIDs = <int>{};
    final uniqueItems = <Item>[];

    for (final item in items) {
      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }

    double subtotal = 0;
    for (final item in items) {
      subtotal += double.tryParse(item.discountPrice) ?? 0;
    }
    final taxPercent = double.tryParse(taxController.text) ?? 0;
    double taxAmount = subtotal * (taxPercent / 100);
    double total = subtotal + taxAmount;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TitleText(title: 'Issued'),
                  ),
                  SizedBox(
                    width: 120,
                    child: TitleText(title: 'Due'),
                  ),
                  Spacer(),
                  TitleText(title: '#'),
                ],
              ),
              const SizedBox(height: 6),
              InvoiceDates(
                date: date,
                dueDate: dueDate,
                number: number,
                onDate: onDate,
                onDueDate: onDueDate,
              ),
              const SizedBox(height: 16),
              const TitleText(title: 'Business account'),
              const SizedBox(height: 6),
              business == null
                  ? InvoiceSelectData(
                      title: 'Choose Account',
                      onPressed: onSelectBusiness,
                    )
                  : InvoiceSelectedData(
                      title: business!.name,
                      onPressed: onSelectBusiness,
                    ),
              const SizedBox(height: 16),
              const TitleText(title: 'Client'),
              const SizedBox(height: 6),
              client == null
                  ? InvoiceSelectData(
                      title: 'Add Client',
                      onPressed: onSelectClient,
                    )
                  : InvoiceSelectedData(
                      title: client!.name,
                      onPressed: onSelectClient,
                    ),
              const SizedBox(height: 16),
              const TitleText(title: 'Items'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: List.generate(
                    uniqueItems.length,
                    (index) {
                      return InvoiceSelectedData(
                        title: uniqueItems[index].title,
                        amount: items.where((element) {
                          return element.id == uniqueItems[index].id;
                        }).length,
                        onPressed: () {
                          onRemoveItem(uniqueItems[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              InvoiceSelectData(
                title: items.isEmpty ? 'Add Item' : 'Add another Item',
                onPressed: onSelectItems,
              ),
              const SizedBox(height: 16),
              const TitleText(title: 'Summary'),
              const SizedBox(height: 6),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$currency${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: AppFonts.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: TitleText(title: 'Taxable?'),
                  ),
                  SwitchButton(
                    isActive: isTaxable,
                    onPressed: onTaxable,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (isTaxable)
                ItemField(
                  controller: taxController,
                  hintText: 'Tax %',
                  decimal: true,
                  onChanged: checkActive,
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: TitleText(title: 'Signature'),
                  ),
                  SwitchButton(
                    isActive: hasSignature,
                    onPressed: onSignature,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (hasSignature) ...[
                SvgPicture.string(signature),
                const SizedBox(height: 16),
                MainButton(
                  title: signature.isEmpty
                      ? 'Create a signature'
                      : 'Change signature',
                  onPressed: onAddSignature,
                ),
              ],
              if (isEstimate) ...[
                const SizedBox(height: 16),
                const TitleText(title: 'Photos'),
                const SizedBox(height: 6),
                InvoiceSelectData(
                  title: 'Add Photo',
                  onPressed: onAddPhotos,
                ),
                const SizedBox(height: 16),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                  builder: (context, state) {
                    return PhotosList(photos: photos);
                  },
                ),
              ],
            ],
          ),
        ),
        MainButtonWrapper(
          children: [
            MainButton(
              title: 'Save',
              active: active,
              onPressed: onCreate,
            ),
          ],
        ),
      ],
    );
  }
}
