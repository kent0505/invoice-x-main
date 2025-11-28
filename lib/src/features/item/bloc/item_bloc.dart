import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/item_repository.dart';
import '../models/item.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _repository;

  ItemBloc({required ItemRepository repository})
      : _repository = repository,
        super(ItemState()) {
    on<ItemEvent>(
      (event, emit) => switch (event) {
        GetItems() => _getItems(event, emit),
        AddItems() => _addItems(event, emit),
        EditItem() => _editItem(event, emit),
        DeleteItem() => _deleteItem(event, emit),
        ReplaceItems() => _replaceItems(event, emit),
      },
    );
  }

  void _getItems(
    GetItems event,
    Emitter<ItemState> emit,
  ) async {
    final items = await _repository.getItems();

    emit(state.copyWith(items: items.reversed.toList()));
  }

  void _addItems(
    AddItems event,
    Emitter<ItemState> emit,
  ) async {
    for (final item in event.items) {
      item.iid = event.iid;
      await _repository.addItem(item);
    }
    add(GetItems());
  }

  void _editItem(
    EditItem event,
    Emitter<ItemState> emit,
  ) async {
    await _repository.editItem(event.item);
    add(GetItems());
  }

  void _deleteItem(
    DeleteItem event,
    Emitter<ItemState> emit,
  ) async {
    await _repository.deleteItem(event.item);
    add(GetItems());
  }

  void _replaceItems(
    ReplaceItems event,
    Emitter<ItemState> emit,
  ) async {
    await _repository.deleteItems(event.iid);
    for (final item in event.items) {
      item.iid = event.iid;
      await _repository.addItem(item);
    }
    add(GetItems());
  }
}
