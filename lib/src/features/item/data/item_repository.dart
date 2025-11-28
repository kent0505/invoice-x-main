import 'package:sqflite/sqflite.dart';

import '../models/item.dart';

abstract interface class ItemRepository {
  const ItemRepository();

  Future<List<Item>> getItems();
  Future<void> addItem(Item item);
  Future<void> editItem(Item item);
  Future<void> deleteItem(Item item);
  Future<void> deleteItems(String iid);
}

final class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Item>> getItems() async {
    final maps = await _db.query(Item.table);
    return maps.map((map) {
      return Item.fromMap(map);
    }).toList();
  }

  @override
  Future<void> addItem(Item item) async {
    await _db.insert(
      Item.table,
      item.toMap(),
    );
  }

  @override
  Future<void> editItem(Item item) async {
    await _db.update(
      Item.table,
      item.toMap(),
      where: 'id = ? AND iid = ?',
      whereArgs: [item.id, item.iid],
    );
  }

  @override
  Future<void> deleteItem(Item item) async {
    await _db.delete(
      Item.table,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  @override
  Future<void> deleteItems(String iid) async {
    await _db.delete(
      Item.table,
      where: 'iid = ?',
      whereArgs: [iid],
    );
  }
}
