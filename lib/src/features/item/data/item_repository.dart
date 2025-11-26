import 'package:sqflite/sqflite.dart';

import '../../invoice/models/invoice.dart';
import '../models/item.dart';

abstract interface class ItemRepository {
  const ItemRepository();

  Future<List<Item>> getItems();
  Future<void> addItem(Item item);
  Future<void> editItem(Item item);
  Future<void> deleteItem(Item item);
  Future<void> addInvoiceItems(Invoice invoice);
  Future<void> deleteInvoiceItems(Invoice invoice);
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
      where: 'id = ?',
      whereArgs: [item.id],
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
  Future<void> addInvoiceItems(Invoice invoice) async {
    for (final item in invoice.items) {
      await _db.insert(
        Item.table,
        item.toMap(),
      );
    }
  }

  @override
  Future<void> deleteInvoiceItems(Invoice invoice) async {
    await _db.delete(
      Item.table,
      where: 'iid = ?',
      whereArgs: [invoice.id],
    );
  }
}
