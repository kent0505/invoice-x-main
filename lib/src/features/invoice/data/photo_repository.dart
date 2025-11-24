import 'package:sqflite/sqflite.dart';

import '../../../core/utils.dart';
import '../models/invoice.dart';
import '../models/photo.dart';

abstract interface class PhotoRepository {
  const PhotoRepository();

  Future<List<Photo>> getPhotos();
  Future<void> addPhotos(List<Photo> photos);
  Future<void> deletePhotos(Invoice invoice);
}

final class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Photo>> getPhotos() async {
    try {
      final maps = await _db.query(Photo.table);
      return maps.map((map) => Photo.fromMap(map)).toList();
    } catch (e) {
      logger(e);
      return [];
    }
  }

  @override
  Future<void> addPhotos(List<Photo> photos) async {
    try {
      for (final photo in photos) {
        await _db.insert(
          Photo.table,
          photo.toMap(),
        );
      }
    } catch (e) {
      logger(e);
    }
  }

  @override
  Future<void> deletePhotos(Invoice invoice) async {
    try {
      await _db.delete(
        Photo.table,
        where: 'id = ?',
        whereArgs: [invoice.id],
      );
    } catch (e) {
      logger(e);
    }
  }
}
