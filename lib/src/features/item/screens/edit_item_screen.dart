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
  final discountController = TextEditingController();

  late Item item;

  bool active = false;

  void onChanged(String _) {
    setState(() {
      active = [
        titleController,
        priceController,
      ].every((element) => element.text.isNotEmpty);
    });
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
    item.title = titleController.text;
    item.type = typeController.text;
    item.price = priceController.text;
    item.discount = discountController.text;

    final bloc = context.read<ItemBloc>();

    if (widget.item == null) {
      bloc.add(AddItems(items: [item]));
    } else {
      bloc.add(EditItem(item: item));
    }

    context.pop();
  }

  @override
  void initState() {
    super.initState();

    titleController.text = widget.item?.title ?? '';
    typeController.text = widget.item?.type ?? '';
    priceController.text = widget.item?.price ?? '';
    discountController.text = widget.item?.discount ?? '';

    item = Item(
      id: widget.item?.id ?? getID(),
      title: titleController.text,
      type: typeController.text,
      price: priceController.text,
      discount: discountController.text,
      iid: widget.item?.iid ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    typeController.dispose();
    priceController.dispose();
    discountController.dispose();
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
                  onChanged: onChanged,
                ),
                const SizedBox(height: 16),
                const TitleText(title: 'Unit Price'),
                Field(
                  controller: priceController,
                  hintText: '0',
                  fieldType: FieldType.decimal,
                  onChanged: onChanged,
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
                const TitleText(
                  title: 'Discount %',
                  additional: 'Optional',
                ),
                // Row(
                //   children: [
                //     const Expanded(
                //       child: TitleText(
                //         title: 'Discount %',
                //         additional: 'Optional',
                //       ),
                //     ),
                //     SwitchButton(
                //       isActive: hasDiscount,
                //       onPressed: onHasDiscount,
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 6),
                // if (hasDiscount)
                Field(
                  controller: discountController,
                  hintText: '0',
                  fieldType: FieldType.decimal,
                  onChanged: onChanged,
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
