part of 'item_bloc.dart';

final class ItemState {
  ItemState({
    this.items = const [],
    this.loading = false,
  });

  final List<Item> items;
  final bool loading;

  ItemState copyWith({
    List<Item>? items,
    bool? loading,
  }) {
    return ItemState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
    );
  }
}
