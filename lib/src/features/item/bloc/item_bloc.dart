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
        AddItem() => _addItem(event, emit),
        AddItems() => _addItems(event, emit),
        EditItem() => _editItem(event, emit),
        DeleteItem() => _deleteItem(event, emit),
      },
    );
  }

  void _getItems(
    GetItems event,
    Emitter<ItemState> emit,
  ) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
    }

    final items = await _repository.getItems();

    emit(state.copyWith(
      items: items,
      loading: false,
    ));
  }

  void _addItem(
    AddItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.addItem(event.item);

    add(GetItems());
  }

  void _addItems(
    AddItems event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.deleteItems(event.id);
    await _repository.addItems(event.items);

    add(GetItems());
  }

  void _editItem(
    EditItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.editItem(event.item);

    add(GetItems());
  }

  void _deleteItem(
    DeleteItem event,
    Emitter<ItemState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.deleteItem(event.item);

    add(GetItems());
  }
}
