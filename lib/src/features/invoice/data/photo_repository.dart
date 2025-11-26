import 'package:sqflite/sqflite.dart';

import '../models/invoice.dart';
import '../models/photo.dart';

abstract interface class PhotoRepository {
  const PhotoRepository();

  Future<List<Photo>> getPhotos();
  Future<void> addPhotos(Invoice invoice);
  Future<void> deletePhotos(Invoice invoice);
}

final class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Photo>> getPhotos() async {
    final maps = await _db.query(Photo.table);
    return maps.map((map) {
      return Photo.fromMap(map);
    }).toList();
  }

  @override
  Future<void> addPhotos(Invoice invoice) async {
    for (final photo in invoice.photos) {
      await _db.insert(
        Photo.table,
        photo.toMap(),
      );
    }
  }

  @override
  Future<void> deletePhotos(Invoice invoice) async {
    await _db.delete(
      Photo.table,
      where: 'iid = ?',
      whereArgs: [invoice.id],
    );
  }
}
