part of 'item_bloc.dart';

@immutable
sealed class ItemEvent {}

final class GetItems extends ItemEvent {}

final class AddItems extends ItemEvent {
  AddItems({
    required this.items,
    this.iid = '',
  });

  final List<Item> items;
  final String iid;
}

final class EditItem extends ItemEvent {
  EditItem({required this.item});

  final Item item;
}

final class DeleteItems extends ItemEvent {
  DeleteItems({
    this.items = const [],
    this.iid = '',
  });

  final List<Item> items;
  final String iid;
}
