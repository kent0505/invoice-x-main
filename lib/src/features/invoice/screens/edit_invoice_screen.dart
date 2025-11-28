import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:invoice_app/src/features/vip/screens/vip_screen.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/date_pick.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/sheet_widget.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../business/screens/business_screen.dart';
import '../../signature/screens/signature_screen.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../item/screens/items_screen.dart';
import '../../onboard/data/onboard_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../../signature/widgets/signature_widget.dart';
import '../../vip/bloc/vip_bloc.dart';
import '../../vip/widgets/vip_widget.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/photo.dart';
import '../widgets/invoice_dates.dart';
import '../widgets/invoice_select_data.dart';
import '../widgets/invoice_selected_data.dart';
import '../widgets/photos_list.dart';
import 'invoice_preview_screen.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final Invoice? invoice;

  static const routePath = '/EditInvoiceScreen';

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  late Invoice invoice;

  final taxController = TextEditingController();

  void onAddSignature() async {
    context.push<String?>(SignatureScreen.routePath).then(
      (value) {
        setState(() {
          invoice.signature = value ?? '';
        });
      },
    );
  }

  void onPreview() {
    context.push(
      InvoicePreviewScreen.routePath,
      extra: invoice,
    );
  }

  void onDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(invoice.date),
    ).then((value) {
      setState(() {
        invoice.date = value.millisecondsSinceEpoch;
      });
    });
  }

  void onDueDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(
        invoice.dueDate == 0 ? getTimestamp() : invoice.dueDate,
      ),
    ).then((value) {
      setState(() {
        invoice.dueDate = value.millisecondsSinceEpoch;
      });
    });
  }

  void onSelectBusiness() {
    if (invoice.business == null) {
      SheetWidget.show<Business?>(
        context: context,
        title: 'Select account',
        child: const BusinessScreen(select: true),
      ).then((business) {
        if (business != null) {
          setState(() {
            invoice.business = business;
            invoice.bid = business.id;
          });
        }
      });
    } else {
      invoice.business = null;
      setState(() {});
    }
  }

  void onSelectClient() {
    if (invoice.client == null) {
      SheetWidget.show<Client?>(
        context: context,
        title: 'Select client',
        child: const ClientsScreen(select: true),
      ).then((client) {
        if (client != null) {
          setState(() {
            invoice.client = client;
            invoice.cid = client.id;
          });
        }
      });
    } else {
      invoice.client = null;
      setState(() {});
    }
  }

  void onSelectItems() async {
    final value = await SheetWidget.show<Item?>(
      context: context,
      title: 'Select item',
      child: const ItemsScreen(select: true),
    );
    if (value == null) return;
    final uniqueInvoiceIDs = <String>{};
    final uniqueItems = <Item>[];
    for (final item in invoice.items) {
      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }
    final isInUniqueItems = uniqueItems.any((item) => item.id == value.id);
    if (isInUniqueItems || uniqueItems.length < 10) {
      invoice.items.add(
        Item(
          id: value.id,
          title: value.title,
          type: value.type,
          price: value.price,
          discount: value.discount,
        ),
      );
    } else {
      if (mounted) {
        DialogWidget.show(
          context,
          title: 'Max Items is 10',
        );
      }
    }
    setState(() {});
  }

  void onRemoveItem(Item item) {
    invoice.items.remove(item);
    setState(() {});
  }

  void onAddPhotos() async {
    final images = await pickImages();
    if (images.isNotEmpty) {
      invoice.photos = [];
      for (final image in images.take(6)) {
        invoice.photos.add(Photo(
          id: invoice.id,
          path: image.path,
        ));
      }
    } else {
      invoice.photos = [];
    }
    setState(() {});
  }

  void onSave() {
    invoice.tax = taxController.text;

    final invoiceBloc = context.read<InvoiceBloc>();
    final itemBloc = context.read<ItemBloc>();
    final vipBloc = context.read<VipBloc>();

    if (widget.invoice == null) {
      if (vipBloc.state.free <= 0) return VipScreen.open(context);

      vipBloc.add(UseFree());
      invoiceBloc.add(AddInvoice(invoice: invoice));
      itemBloc.add(AddItems(
        items: invoice.items,
        iid: invoice.id,
      ));
      context.pop();
    } else {
      invoiceBloc.add(EditInvoice(invoice: invoice));
      itemBloc.add(ReplaceItems(
        items: invoice.items,
        iid: invoice.id,
      ));
      context.pop();
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    taxController.text = widget.invoice?.tax ?? '';

    final template = context.read<OnboardRepository>().getTemplate();

    final invoiceState = context.read<InvoiceBloc>().state;
    final businessState = context.read<BusinessBloc>().state;
    final clientState = context.read<ClientBloc>().state;
    final itemState = context.read<ItemBloc>().state;

    invoice = Invoice(
      id: widget.invoice?.id ?? getID(),
      number: widget.invoice?.number ?? invoiceState.invoices.length + 1,
      template: widget.invoice?.template ?? template,
      date: widget.invoice?.date ?? getTimestamp(),
      dueDate: widget.invoice?.dueDate ?? 0,
      bid: widget.invoice?.bid ?? 0,
      cid: widget.invoice?.cid ?? 0,
      paymentMethod: widget.invoice?.paymentMethod ?? '',
      paymentDate: widget.invoice?.paymentDate ?? 0,
      tax: taxController.text,
      signature: widget.invoice?.signature ?? '',
      business: businessState.businesses.firstWhereOrNull((business) {
        return business.id == widget.invoice?.bid;
      }),
      client: clientState.clients.firstWhereOrNull((client) {
        return client.id == widget.invoice?.cid;
      }),
      items: itemState.items.reversed.where((item) {
        return item.iid == widget.invoice?.id;
      }).toList(),
      photos: invoiceState.photos.where((photo) {
        return photo.id == widget.invoice?.id;
      }).toList(),
    );
  }

  @override
  void dispose() {
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    final currency = context.read<ProfileRepository>().getCurrency();

    double subtotal = 0;
    for (final item in invoice.items) {
      subtotal += getItemPrice(item);
    }
    final taxPercent = double.tryParse(taxController.text) ?? 0;
    double taxAmount = subtotal * (taxPercent / 100);
    double total = subtotal + taxAmount;

    return Scaffold(
      appBar: Appbar(
        title: widget.invoice == null ? 'Create new invoice' : 'Edit invoice',
        right: Button(
          onPressed: onPreview,
          child: Text(
            'Preview',
            style: TextStyle(
              color: colors.accent,
              fontSize: 14,
              fontFamily: AppFonts.w400,
            ),
          ),
        ),
      ),
      body: Column(
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
                InvoiceDates(
                  date: invoice.date,
                  dueDate: invoice.dueDate,
                  number: invoice.number,
                  onDate: onDate,
                  onDueDate: onDueDate,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Business account'),
                invoice.business == null
                    ? InvoiceSelectData(
                        title: 'Choose Account',
                        onPressed: onSelectBusiness,
                      )
                    : InvoiceSelectedData(
                        title: invoice.business!.name,
                        onPressed: onSelectBusiness,
                      ),
                const SizedBox(height: 16),
                const TitleText(title: 'Client'),
                invoice.client == null
                    ? InvoiceSelectData(
                        title: 'Add Client',
                        onPressed: onSelectClient,
                      )
                    : InvoiceSelectedData(
                        title: invoice.client!.name,
                        onPressed: onSelectClient,
                      ),
                const SizedBox(height: 16),
                const TitleText(title: 'Items'),
                Container(
                  decoration: BoxDecoration(
                    color: colors.tertiary1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Builder(
                    builder: (context) {
                      final uniqueInvoiceIDs = <String>{};
                      final uniqueItems = <Item>[];

                      for (final item in invoice.items) {
                        if (uniqueInvoiceIDs.add(item.id)) {
                          uniqueItems.add(item);
                        }
                      }

                      return Column(
                        children: List.generate(
                          uniqueItems.length,
                          (index) {
                            return InvoiceSelectedData(
                              title: uniqueItems[index].title,
                              amount: invoice.items.where((item) {
                                return item.id == uniqueItems[index].id;
                              }).length,
                              onPressed: () {
                                onRemoveItem(uniqueItems[index]);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (invoice.items.isNotEmpty) const SizedBox(height: 8),
                InvoiceSelectData(
                  title: 'Add item',
                  onPressed: onSelectItems,
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Photo',
                  right: VipWidget(),
                ),
                PhotosList(photos: invoice.photos),
                if (invoice.photos.isNotEmpty) const SizedBox(height: 8),
                InvoiceSelectData(
                  title: 'Add photo',
                  onPressed: onAddPhotos,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Tax'),
                Field(
                  controller: taxController,
                  hintText: 'Tax %',
                  fieldType: FieldType.decimal,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Summary'),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.tertiary1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
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
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SignatureWidget(string: invoice.signature),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: invoice.signature.isEmpty
                    ? 'Create a signature'
                    : 'Change signature',
                color: colors.bg,
                onPressed: onAddSignature,
              ),
              MainButton(
                title: 'Save',
                active: invoice.business != null &&
                    invoice.client != null &&
                    invoice.items.isNotEmpty,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
