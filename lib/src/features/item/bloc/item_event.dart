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

final class DeleteItem extends ItemEvent {
  DeleteItem({required this.item});

  final Item item;
}

final class ReplaceItems extends ItemEvent {
  ReplaceItems({
    this.items = const [],
    required this.iid,
  });

  final List<Item> items;
  final String iid;
}
