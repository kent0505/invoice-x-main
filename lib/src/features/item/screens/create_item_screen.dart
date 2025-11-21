import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';
import '../widgets/item_body.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key, required this.select});

  final bool select;

  static const routePath = '/CreateItemScreen';

  @override
  State<CreateItemScreen> createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  final titleController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();
  final discountPriceController = TextEditingController();

  bool active = false;
  bool saveToItems = false;
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

  void onSaveToItems() {
    setState(() {
      saveToItems = !saveToItems;
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

  void save(Item item) {
    context.read<ItemBloc>().add(AddItem(item: item));
  }

  void onContinue() {
    final item = Item(
      title: titleController.text,
      type: typeController.text,
      price: priceController.text,
      discountPrice: discountPriceController.text.isEmpty
          ? priceController.text
          : discountPriceController.text,
    );

    if (widget.select) {
      if (saveToItems) save(item);
      context.pop(item);
    } else {
      save(item);
      context.pop();
    }
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
      appBar: const Appbar(title: 'New Item'),
      body: ItemBody(
        select: widget.select,
        saveToItems: saveToItems,
        hasDiscount: hasDiscount,
        active: active,
        titleController: titleController,
        priceController: priceController,
        typeController: typeController,
        discountPriceController: discountPriceController,
        checkActive: checkActive,
        onSaveToItems: onSaveToItems,
        onHasDiscount: onHasDiscount,
        onContinue: onContinue,
      ),
    );
  }
}
