import 'package:sqflite/sqflite.dart';

import '../../../core/utils.dart';
import '../models/invoice.dart';
import '../models/photo.dart';

abstract interface class InvoiceRepository {
  const InvoiceRepository();

  Future<List<Invoice>> getInvoices();
  Future<void> addInvoice(Invoice invoice);
  Future<void> editInvoice(Invoice invoice);
  Future<void> deleteInvoice(Invoice invoice);
  // Future<void> deleteItems(Invoice invoice);
}

final class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Invoice>> getInvoices() async {
    try {
      final maps = await _db.query(Invoice.table);
      return maps.map((map) => Invoice.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _db.insert(
        Invoice.table,
        invoice.toMap(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> editInvoice(
    Invoice invoice, {
    List<Photo> photos = const [],
  }) async {
    try {
      await _db.update(
        Invoice.table,
        invoice.toMap(),
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteInvoice(Invoice invoice) async {
    try {
      await _db.delete(
        Invoice.table,
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  // @override
  // Future<void> deleteItems(Invoice invoice) async {
  //   await _db.delete(
  //     Item.table,
  //     where: 'invoiceID = ?',
  //     whereArgs: [invoice.id],
  //   );
  // }
}
