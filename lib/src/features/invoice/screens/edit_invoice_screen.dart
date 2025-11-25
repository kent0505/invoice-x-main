import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/date_pick.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../../business/bloc/business_bloc.dart';
import '../../business/models/business.dart';
import '../../business/screens/signature_screen.dart';
import '../../client/bloc/client_bloc.dart';
import '../../client/models/client.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
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
  int id = 0;
  int number = 0;
  int date = 0;
  int dueDate = 0;
  Business? business;
  Client? client;
  List<Item> items = [];
  List<Photo> photos = [];
  String signature = '';
  bool isTaxable = false;
  bool hasSignature = false;

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

  void onSignature() {
    hasSignature = !hasSignature;
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
    if (widget.invoice == null) {
      context.push(
        InvoicePreviewScreen.routePath,
        extra: Invoice(
          id: id,
          number: number,
          template: context.read<OnboardRepository>().getTemplateID(),
          date: date,
          dueDate: dueDate,
          businessID: 0,
          clientID: 0,
          tax: '',
          imageSignature: hasSignature ? signature : '',
          isEstimate: false,
          business: business,
          client: client,
          items: items,
          photos: photos,
        ),
      );
    } else {
      final invoice = widget.invoice!;
      context.push(
        InvoicePreviewScreen.routePath,
        extra: Invoice(
          id: invoice.id,
          number: invoice.number,
          template: invoice.template,
          date: date,
          dueDate: dueDate,
          businessID: 0,
          clientID: 0,
          tax: taxController.text,
          imageSignature: hasSignature ? signature : '',
          isEstimate: invoice.isEstimate,
          business: business,
          client: client,
          items: items,
          photos: photos,
        ),
      );
    }
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
    // if (business == null) {
    // context.push<Business?>(BusinessScreen.routePath).then((value) {
    //   if (value != null) {
    //     business = value;
    //     setState(() {});
    //   }
    // });
    // } else {
    //   business = null;
    //   setState(() {});
    // }
  }

  void onSelectClient() {
    // if (client == null) {
    //   context.push<Client?>(ClientsScreen.routePath, extra: true).then((value) {
    //     if (value != null) {
    //       client = value;
    //       setState(() {});
    //     }
    //   });
    // } else {
    //   client = null;
    //   setState(() {});
    // }
  }

  void onSelectItems() async {
    // final value = await context.push<Item?>(ItemsScreen.routePath, extra: true);
    // if (value == null) return;
    // final uniqueInvoiceIDs = <int>{};
    // final uniqueItems = <Item>[];
    // for (final item in items) {
    //   if (uniqueInvoiceIDs.add(item.id)) {
    //     uniqueItems.add(item);
    //   }
    // }
    // final isInUniqueItems = uniqueItems.any((item) => item.id == value.id);
    // if (isInUniqueItems || uniqueItems.length < 10) {
    //   items.add(
    //     Item(
    //       id: value.id,
    //       title: value.title,
    //       type: value.type,
    //       price: value.price,
    //       discountPrice: value.discountPrice,
    //       invoiceID: widget.invoice?.id ?? id,
    //     ),
    //   );
    // } else {
    //   if (mounted) {
    //     DialogWidget.show(context, title: 'Max Items is 10');
    //   }
    // }
    // setState(() {});
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
        photos.add(Photo(
          id: widget.invoice?.id ?? id,
          path: image.path,
        ));
      }
    } else {
      photos = [];
    }
    setState(() {});
  }

  void onSave() {
    if (widget.invoice == null) {
      context.read<InvoiceBloc>().add(
            AddInvoice(
              invoice: Invoice(
                id: id,
                number: number,
                template: context.read<OnboardRepository>().getTemplateID(),
                date: date,
                dueDate: dueDate,
                businessID: business!.id,
                clientID: client!.id,
                tax: '',
                imageSignature: signature,
                isEstimate: false,
              ),
              photos: photos,
            ),
          );
    } else {
      final invoice = Invoice(
        id: widget.invoice!.id,
        number: widget.invoice!.number,
        template: widget.invoice!.template,
        date: date,
        dueDate: dueDate,
        businessID: business!.id,
        clientID: client!.id,
        paymentDate: widget.invoice!.paymentDate,
        tax: taxController.text,
        paymentMethod: widget.invoice!.paymentMethod,
        imageSignature: hasSignature ? signature : '',
        isEstimate: widget.invoice!.isEstimate,
        business: business,
        client: client,
        items: items,
        photos: photos,
      );
      context.read<InvoiceBloc>().add(EditInvoice(invoice: invoice));
    }
    context.read<ItemBloc>().add(AddInvoiceItems(
          id: widget.invoice?.id ?? id,
          items: items,
        ));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.invoice == null) {
      id = getTimestamp();
      date = id;
      final state = context.read<InvoiceBloc>().state;
      if (state is InvoiceLoaded) {
        number = state.invoices.length + 1;
      }
    } else {
      date = widget.invoice!.date;
      dueDate = widget.invoice!.dueDate;
      signature = widget.invoice!.imageSignature;
      hasSignature = widget.invoice!.imageSignature.isNotEmpty;
      taxController.text = widget.invoice!.tax;
      isTaxable = widget.invoice!.tax.isNotEmpty;
      business = context
          .read<BusinessBloc>()
          .state
          .businesses
          .firstWhereOrNull((business) {
        return business.id == widget.invoice!.businessID;
      });
      client =
          context.read<ClientBloc>().state.clients.firstWhereOrNull((client) {
        return client.id == widget.invoice!.clientID;
      });
      items = context.read<ItemBloc>().state.items.where((element) {
        return element.invoiceID == widget.invoice!.id;
      }).toList();
      final state = context.read<InvoiceBloc>().state;
      if (state is InvoiceLoaded) {
        photos = state.photos.where((element) {
          return element.id == widget.invoice!.id;
        }).toList();
      }
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
      subtotal += double.tryParse(item.discountPrice) ?? 0;
    }
    final taxPercent = double.tryParse(taxController.text) ?? 0;
    double taxAmount = subtotal * (taxPercent / 100);
    double total = subtotal + taxAmount;

    return Scaffold(
      appBar: Appbar(
        title: widget.invoice == null ? 'Create invoice' : 'Edit invoice',
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
                  Field(
                    controller: taxController,
                    hintText: 'Tax %',
                    fieldType: FieldType.decimal,
                    onChanged: (_) {
                      setState(() {});
                    },
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
                if (hasSignature) SvgPicture.string(signature),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              if (hasSignature) ...[
                MainButton(
                  title: signature.isEmpty
                      ? 'Create a signature'
                      : 'Change signature',
                  color: colors.bg,
                  onPressed: onAddSignature,
                ),
                const SizedBox(height: 16),
              ],
              MainButton(
                title: 'Save',
                active: business != null &&
                        client != null &&
                        items.isNotEmpty &&
                        isTaxable
                    ? taxController.text.isNotEmpty
                    : true,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
