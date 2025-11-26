import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
import '../../business/screens/signature_screen.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../item/screens/items_screen.dart';
import '../../onboard/data/onboard_repository.dart';
import '../../profile/data/profile_repository.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/photo.dart';
import '../widgets/invoice_dates.dart';
import '../widgets/invoice_select_data.dart';
import '../widgets/invoice_selected_data.dart';
import 'invoice_preview_screen.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final Invoice? invoice;

  static const routePath = '/EditInvoiceScreen';

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
  int number = 0;
  int date = 0;
  int dueDate = 0;
  Business? business;
  Client? client;
  List<Item> items = [];
  List<Photo> photos = [];
  String signature = '';
  bool isTaxable = false;

  final taxController = TextEditingController();

  void onTaxable() {
    if (isTaxable) {
      taxController.clear();
      isTaxable = false;
    } else {
      isTaxable = true;
    }
    setState(() {});
  }

  void onAddSignature() async {
    context.push<String?>(SignatureScreen.routePath).then(
      (value) {
        if (value != null) {
          setState(() {
            signature = value;
          });
        }
      },
    );
  }

  void onPreview() {
    context.push(
      InvoicePreviewScreen.routePath,
      extra: Invoice(
        number: widget.invoice?.number ?? number,
        template: widget.invoice?.template ??
            context.read<OnboardRepository>().getTemplateID(),
        date: date,
        dueDate: dueDate,
        bid: 0,
        cid: 0,
        tax: taxController.text,
        signature: signature,
        business: business,
        client: client,
        items: items,
        photos: photos,
      ),
    );
  }

  void onDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(date),
    ).then((value) {
      setState(() {
        date = value.millisecondsSinceEpoch;
      });
    });
  }

  void onDueDate() {
    DatePick.show(
      context,
      DateTime.fromMillisecondsSinceEpoch(getTimestamp()),
    ).then((value) {
      setState(() {
        dueDate = value.millisecondsSinceEpoch;
      });
    });
  }

  void onSelectBusiness() {
    if (business == null) {
      SheetWidget.show<Business?>(
        context: context,
        title: 'Select account',
        child: const BusinessScreen(select: true),
      ).then((value) {
        if (value != null) {
          setState(() {
            business = value;
          });
        }
      });
    } else {
      business = null;
      setState(() {});
    }
  }

  void onSelectClient() {
    if (client == null) {
      SheetWidget.show<Client?>(
        context: context,
        title: 'Select client',
        child: const ClientsScreen(select: true),
      ).then((value) {
        if (value != null) {
          setState(() {
            client = value;
          });
        }
      });
    } else {
      client = null;
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
    final uniqueInvoiceIDs = <int>{};
    final uniqueItems = <Item>[];
    for (final item in items) {
      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }
    final isInUniqueItems = uniqueItems.any((item) => item.id == value.id);
    if (isInUniqueItems || uniqueItems.length < 10) {
      items.add(
        Item(
          id: value.id,
          title: value.title,
          type: value.type,
          price: value.price,
          discountPrice: value.discountPrice,
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
    items.remove(item);
    setState(() {});
  }

  void onAddPhotos() async {
    final images = await pickImages();
    if (images.isNotEmpty) {
      photos = [];
      for (final image in images.take(6)) {
        photos.add(Photo(path: image.path));
      }
    } else {
      photos = [];
    }
    setState(() {});
  }

  void onSave() {
    final invoice = Invoice(
      id: widget.invoice?.id ?? 0,
      number: widget.invoice?.number ?? number,
      template: widget.invoice?.template ??
          context.read<OnboardRepository>().getTemplateID(),
      date: date,
      dueDate: dueDate,
      bid: business!.id,
      cid: client!.id,
      paymentDate: widget.invoice?.paymentDate ?? 0,
      paymentMethod: widget.invoice?.paymentMethod ?? '',
      tax: taxController.text,
      signature: signature,
      business: business,
      client: client,
      items: items,
      photos: photos,
    );

    context.read<InvoiceBloc>().add(widget.invoice == null
        ? AddInvoice(invoice: invoice)
        : EditInvoice(invoice: invoice));
    context.pop();
  }

  @override
  void initState() {
    super.initState();

    final state = context.read<InvoiceBloc>().state;

    if (widget.invoice == null) {
      date = getTimestamp();
      number = state.invoices.length + 1;
    } else {
      number = widget.invoice!.number;
      date = widget.invoice!.date;
      dueDate = widget.invoice!.dueDate;
      signature = widget.invoice!.signature;
      taxController.text = widget.invoice!.tax;
      isTaxable = widget.invoice!.tax.isNotEmpty;
      business = context
          .read<BusinessBloc>()
          .state
          .businesses
          .firstWhereOrNull((business) {
        return business.id == widget.invoice!.bid;
      });
      client =
          context.read<ClientBloc>().state.clients.firstWhereOrNull((client) {
        return client.id == widget.invoice!.cid;
      });
      items = context.read<ItemBloc>().state.items.where((item) {
        return item.iid == widget.invoice!.id;
      }).toList();
      photos = state.photos.where((photo) {
        return photo.iid == widget.invoice!.id;
      }).toList();
    }
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
    final uniqueInvoiceIDs = <int>{};
    final uniqueItems = <Item>[];

    for (final item in items) {
      if (uniqueInvoiceIDs.add(item.id)) {
        uniqueItems.add(item);
      }
    }

    double subtotal = 0;
    for (final item in items) {
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
                  date: date,
                  dueDate: dueDate,
                  number: number,
                  onDate: onDate,
                  onDueDate: onDueDate,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Business account'),
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
                Container(
                  decoration: BoxDecoration(
                    color: colors.tertiary1,
                    borderRadius: BorderRadius.circular(16),
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
                const SizedBox(height: 8),
                InvoiceSelectData(
                  title: 'Add item',
                  onPressed: onSelectItems,
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
                if (signature.isNotEmpty) SvgPicture.string(signature),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: signature.isEmpty
                    ? 'Create a signature'
                    : 'Change signature',
                color: colors.bg,
                onPressed: onAddSignature,
              ),
              MainButton(
                title: 'Save',
                active: business != null && client != null && items.isNotEmpty,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
