import 'package:sqflite/sqflite.dart';

import '../../../core/utils.dart';
import '../models/business.dart';

abstract interface class BusinessRepository {
  const BusinessRepository();

  Future<List<Business>> getBusiness();
  Future<void> addBusiness(Business business);
  Future<void> editBusiness(Business business);
  Future<void> deleteBusiness(Business business);
}

final class BusinessRepositoryImpl implements BusinessRepository {
  BusinessRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Business>> getBusiness() async {
    try {
      final maps = await _db.query(Business.table);
      return maps.map((map) => Business.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addBusiness(Business business) async {
    try {
      await _db.insert(
        Business.table,
        business.toMap(),
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> editBusiness(Business business) async {
    try {
      await _db.update(
        Business.table,
        business.toMap(),
        where: 'id = ?',
        whereArgs: [business.id],
      );
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deleteBusiness(Business business) async {
    try {
      await _db.delete(
        Business.table,
        where: 'id = ?',
        whereArgs: [business.id],
      );
    } catch (e) {
      logger(e);
    }
  }
}
