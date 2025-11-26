import 'package:sqflite/sqflite.dart';

import '../models/invoice.dart';
import '../models/photo.dart';

abstract interface class InvoiceRepository {
  const InvoiceRepository();

  Future<List<Invoice>> getInvoices();
  Future<int> addInvoice(Invoice invoice);
  Future<void> editInvoice(Invoice invoice);
  Future<void> deleteInvoice(Invoice invoice);
}

final class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Invoice>> getInvoices() async {
    final maps = await _db.query(Invoice.table);
    return maps.map((map) {
      return Invoice.fromMap(map);
    }).toList();
  }

  @override
  Future<int> addInvoice(Invoice invoice) async {
    return await _db.insert(
      Invoice.table,
      invoice.toMap(),
    );
  }

  @override
  Future<void> editInvoice(
    Invoice invoice, {
    List<Photo> photos = const [],
  }) async {
    await _db.update(
      Invoice.table,
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  @override
  Future<void> deleteInvoice(Invoice invoice) async {
    await _db.delete(
      Invoice.table,
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }
}
