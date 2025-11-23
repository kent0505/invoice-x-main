import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/date_pick.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../business/models/business.dart';
import '../../business/screens/business_screen.dart';
import '../../business/screens/signature_screen.dart';
import '../../client/models/client.dart';
import '../../client/screens/clients_screen.dart';
import '../../item/bloc/item_bloc.dart';
import '../../item/models/item.dart';
import '../../item/screens/items_screen.dart';
import '../../onboard/data/onboard_repository.dart';
import '../../pro/bloc/pro_bloc.dart';
import '../../pro/data/pro_repository.dart';
import '../../pro/screens/pro_page.dart';
import '../bloc/invoice_bloc.dart';
import '../models/invoice.dart';
import '../models/photo.dart';
import '../widgets/invoice_appbar.dart';
import '../widgets/invoice_body.dart';
import 'invoice_preview_screen.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  static const routePath = '/CreateInvoiceScreen';

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
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
    final isPro = context.read<ProBloc>().state.isPro;
    final available = context.read<ProRepository>().getAvailable();
    if (isPro || available >= 1) {
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
      context.push(
        ProScreen.routePath,
        extra: Identifiers.paywall1,
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
          invoiceID: id,
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
          id: id,
          path: image.path,
        ));
      }
      setState(() {});
    }
  }

  void onCreate() {
    final isPro = context.read<ProBloc>().state.isPro;
    final available = context.read<ProRepository>().getAvailable();
    if (isPro || available >= 1) {
      context.read<ProRepository>().saveAvailable(available - 1);
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
      context.read<ItemBloc>().add(AddItems(id: id, items: items));
      context.pop();
    } else {
      context.push(
        ProScreen.routePath,
        extra: Identifiers.paywall1,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    id = getTimestamp();
    date = id;
    final state = context.read<InvoiceBloc>().state;
    if (state is InvoiceLoaded) {
      number = state.invoices.length + 1;
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
        title: 'New invoice',
        onPreview: onPreview,
      ),
      body: InvoiceBody(
        isEstimate: false,
        active:
            business != null && client != null && items.isNotEmpty && isTaxable
                ? taxController.text.isNotEmpty
                : true,
        date: date,
        dueDate: dueDate,
        onDate: onDate,
        onDueDate: onDueDate,
        number: number,
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
        onCreate: onCreate,
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
