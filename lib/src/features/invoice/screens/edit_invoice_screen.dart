import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/date_pick.dart';
import '../../../core/widgets/dialog_widget.dart';
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
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/photo.dart';
import '../widgets/invoice_appbar.dart';
import '../widgets/invoice_body.dart';
import 'invoice_preview_screen.dart';

class EditInvoiceScreen extends StatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final Invoice invoice;

  static const routePath = '/EditInvoiceScreen';

  @override
  State<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends State<EditInvoiceScreen> {
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
    context.push(
      InvoicePreviewScreen.routePath,
      extra: Invoice(
        id: widget.invoice.id,
        number: widget.invoice.number,
        template: widget.invoice.template,
        date: date,
        dueDate: dueDate,
        businessID: 0,
        clientID: 0,
        tax: taxController.text,
        imageSignature: hasSignature ? signature : '',
        isEstimate: widget.invoice.isEstimate,
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
      context
          .push<Business?>(BusinessScreen.routePath, extra: true)
          .then((value) {
        if (value != null) {
          business = value;
          setState(() {});
        }
      });
    } else {
      business = null;
      setState(() {});
    }
  }

  void onSelectClient() {
    if (client == null) {
      context.push<Client?>(ClientsScreen.routePath, extra: true).then((value) {
        if (value != null) {
          client = value;
          setState(() {});
        }
      });
    } else {
      client = null;
      setState(() {});
    }
  }

  void onSelectItems() async {
    final value = await context.push<Item?>(ItemsScreen.routePath, extra: true);
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
          invoiceID: widget.invoice.id,
        ),
      );
    } else {
      if (mounted) {
        DialogWidget.show(context, title: 'Max Items is 10');
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
        photos.add(Photo(
          id: widget.invoice.id,
          path: image.path,
        ));
      }
    } else {
      photos = [];
    }
    setState(() {});
  }

  void onEdit() {
    final invoice = Invoice(
      id: widget.invoice.id,
      number: widget.invoice.number,
      template: widget.invoice.template,
      date: date,
      dueDate: dueDate,
      businessID: business!.id,
      clientID: client!.id,
      paymentDate: widget.invoice.paymentDate,
      tax: taxController.text,
      paymentMethod: widget.invoice.paymentMethod,
      imageSignature: hasSignature ? signature : '',
      isEstimate: widget.invoice.isEstimate,
      business: business,
      client: client,
      items: items,
      photos: photos,
    );
    context.read<InvoiceBloc>().add(EditInvoice(invoice: invoice));
    context.read<ItemBloc>().add(AddItems(id: widget.invoice.id, items: items));
    context.pop(invoice);
  }

  @override
  void initState() {
    super.initState();
    date = widget.invoice.date;
    dueDate = widget.invoice.dueDate;
    signature = widget.invoice.imageSignature;
    hasSignature = widget.invoice.imageSignature.isNotEmpty;
    taxController.text = widget.invoice.tax;
    isTaxable = widget.invoice.tax.isNotEmpty;
    business = context
        .read<BusinessBloc>()
        .state
        .firstWhereOrNull((element) => element.id == widget.invoice.businessID);
    client = context
        .read<ClientBloc>()
        .state
        .firstWhereOrNull((element) => element.id == widget.invoice.clientID);
    items = context
        .read<ItemBloc>()
        .state
        .where((element) => element.invoiceID == widget.invoice.id)
        .toList();

    final state = context.read<InvoiceBloc>().state;
    if (state is InvoiceLoaded) {
      photos = state.photos.where((element) {
        return element.id == widget.invoice.id;
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
    return Scaffold(
      appBar: InvoiceAppbar(
        title: widget.invoice.isEstimate ? 'Edit estimate' : 'Edit invoice',
        onPreview: onPreview,
      ),
      body: InvoiceBody(
        isEstimate: widget.invoice.isEstimate,
        active:
            business != null && client != null && items.isNotEmpty && isTaxable
                ? taxController.text.isNotEmpty
                : true,
        date: date,
        dueDate: dueDate,
        onDate: onDate,
        onDueDate: onDueDate,
        number: widget.invoice.number,
        business: business,
        onSelectBusiness: onSelectBusiness,
        client: client,
        onSelectClient: onSelectClient,
        items: items,
        onSelectItems: onSelectItems,
        onRemoveItem: onRemoveItem,
        hasSignature: hasSignature,
        signature: signature,
        onSignature: onSignature,
        onAddSignature: onAddSignature,
        photos: photos,
        onAddPhotos: onAddPhotos,
        onCreate: onEdit,
        isTaxable: isTaxable,
        onTaxable: onTaxable,
        taxController: taxController,
        checkActive: (_) {
          setState(() {});
        },
      ),
    );
  }
}
