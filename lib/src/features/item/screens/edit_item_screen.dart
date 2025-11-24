import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../../../core/widgets/appbar.dart';
import '../../../core/widgets/button.dart';
import '../../../core/widgets/dialog_widget.dart';
import '../../../core/widgets/field.dart';
import '../../../core/widgets/main_button.dart';
import '../../../core/widgets/svg_widget.dart';
import '../../../core/widgets/switch_button.dart';
import '../../../core/widgets/title_text.dart';
import '../bloc/item_bloc.dart';
import '../models/item.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({super.key, required this.item});

  final Item? item;

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

  void onDelete() {
    DialogWidget.show(
      context,
      title: 'Delete item?',
      delete: true,
      onPressed: () {
        context.read<ItemBloc>().add(DeleteItem(item: widget.item!));
        context.pop();
        context.pop();
      },
    );
  }

  void onSave() {
    if (widget.item == null) {
      final item = Item(
        title: titleController.text,
        type: typeController.text,
        price: priceController.text,
        discountPrice: discountPriceController.text.isEmpty
            ? priceController.text
            : discountPriceController.text,
      );
      context.read<ItemBloc>().add(AddItem(item: item));
    } else {
      final item = widget.item!;
      item.title = titleController.text;
      item.type = typeController.text;
      item.price = priceController.text;
      item.discountPrice = discountPriceController.text;
      context.read<ItemBloc>().add(EditItem(item: item));
    }
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      titleController.text = widget.item!.title;
      typeController.text = widget.item!.type;
      priceController.text = widget.item!.price;
      discountPriceController.text = widget.item!.discountPrice;
      hasDiscount = widget.item!.discountPrice.isNotEmpty;
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
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      appBar: Appbar(
        title: widget.item == null ? 'Add item' : 'Edit item',
        right: widget.item == null
            ? null
            : Button(
                onPressed: onDelete,
                child: SvgWidget(
                  Assets.delete,
                  color: colors.text,
                ),
              ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const TitleText(title: 'Name'),
                Field(
                  controller: titleController,
                  hintText: 'Full name',
                  onChanged: checkActive,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Unit Price'),
                Field(
                  controller: priceController,
                  hintText: '0',
                  fieldType: FieldType.decimal,
                  onChanged: checkActive,
                ),
                const SizedBox(height: 16),
                const TitleText(
                  title: 'Unit Type',
                  additional: 'Optional',
                ),
                Field(
                  controller: typeController,
                  hintText: 'Type',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: TitleText(
                        title: 'Discount %',
                        additional: 'Optional',
                      ),
                    ),
                    SwitchButton(
                      isActive: hasDiscount,
                      onPressed: onHasDiscount,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (hasDiscount)
                  Field(
                    controller: discountPriceController,
                    hintText: '0',
                    fieldType: FieldType.decimal,
                    onChanged: checkActive,
                  ),
              ],
            ),
          ),
          MainButtonWrapper(
            children: [
              MainButton(
                title: 'Save',
                active: active,
                onPressed: onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

   // if (select) ...[
                //   const SizedBox(height: 16),
                //   Row(
                //     children: [
                //       const Expanded(
                //         child: TitleText(title: 'Save to Items catalog'),
                //       ),
                //       SwitchButton(
                //         isActive: saveToItems,
                //         onPressed: onSaveToItems,
                //       ),
                //     ],
                //   ),
                // ],