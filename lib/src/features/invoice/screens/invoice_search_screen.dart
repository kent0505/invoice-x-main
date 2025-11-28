import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/field.dart';
import '../bloc/invoice_bloc.dart';
import '../widgets/invoices_list.dart';

class InvoiceSearchScreen extends StatefulWidget {
  const InvoiceSearchScreen({super.key});

  static const routePath = '/InvoiceSearchScreen';

  @override
  State<InvoiceSearchScreen> createState() => _InvoiceSearchScreenState();
}

class _InvoiceSearchScreenState extends State<InvoiceSearchScreen> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        right: Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Center(
              child: SizedBox(
                height: 44,
                child: Field(
                  controller: searchController,
                  focusNode: focusNode,
                  hintText: 'Sarch',
                  asset: Assets.search,
                  fieldType: FieldType.number,
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          final query = searchController.text.toLowerCase();

          final invoices = query.isEmpty
              ? state.invoices
              : state.invoices.where((invoice) {
                  return invoice.number.toString() == query;
                }).toList();

          return InvoicesList(invoices: invoices);
        },
      ),
    );
  }
}
