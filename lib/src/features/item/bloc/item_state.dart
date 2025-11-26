part of 'item_bloc.dart';

final class ItemState {
  ItemState({
    this.items = const [],
  });

  final List<Item> items;

  ItemState copyWith({
    List<Item>? items,
  }) {
    return ItemState(
      items: items ?? this.items,
    );
  }
}
