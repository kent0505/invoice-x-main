import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoice_app/src/core/utils.dart';

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
        AddItems() => _addItem(event, emit),
        EditItem() => _editItem(event, emit),
        DeleteItems() => _deleteItem(event, emit),
      },
    );
  }

  void _getItems(
    GetItems event,
    Emitter<ItemState> emit,
  ) async {
    final items = await _repository.getItems();

    logger('ITEMS = ${items.length}');

    emit(state.copyWith(items: items.reversed.toList()));
  }

  void _addItem(
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
    DeleteItems event,
    Emitter<ItemState> emit,
  ) async {
    await _repository.deleteItems(event.iid);
    for (final item in event.items) {
      await _repository.deleteItem(item);
    }
    add(GetItems());
  }
}
