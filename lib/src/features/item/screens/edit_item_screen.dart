import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/svg_widget.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_body.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final Item item;

  static const routePath = '/EditItemScreen';

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();

  bool active = true;
  bool hasDiscount = false;

  void checkActive(String _) {
    setState(() {
      active = checkControllers([
        titleController,
        priceController,
        if (hasDiscount) discountPriceController,
      ]);
    });
  }

  void onHasDiscount() {
    if (hasDiscount) {
      discountPriceController.clear();
      hasDiscount = false;
    } else {
      hasDiscount = true;
    }
    checkActive('');
  }

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete?',
      delete: true,
      onPressed: () {
        context.read<ItemBloc>().add(DeleteItem(item: widget.item));
        context.pop();
        context.pop();
      },
    );
  }

  void onEdit() {
    final item = widget.item;
    item.title = titleController.text;
    item.type = typeController.text;
    item.price = priceController.text;
    item.discountPrice = discountPriceController.text;
    context.read<ItemBloc>().add(EditItem(item: item));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.item.title;
    typeController.text = widget.item.type;
    priceController.text = widget.item.price;
    discountPriceController.text = widget.item.discountPrice;
    hasDiscount = widget.item.discountPrice.isNotEmpty;
  }

  @override
  void dispose() {
    titleController.dispose();
    typeController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Appbar(
        title: 'Edit Item',
        right: Button(
          onPressed: onDelete,
          child: const SvgWidget(Assets.delete),
        ),
      ),
      body: ItemBody(
        select: false,
        saveToItems: false,
        hasDiscount: hasDiscount,
        active: active,
        titleController: titleController,
        priceController: priceController,
        typeController: typeController,
        discountPriceController: discountPriceController,
        onSaveToItems: () {},
        checkActive: checkActive,
        onHasDiscount: onHasDiscount,
        onContinue: onEdit,
      ),
    );
  }
}
