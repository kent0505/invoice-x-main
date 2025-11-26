import 'package:sqflite/sqflite.dart';

import '../models/photo.dart';

abstract interface class PhotoRepository {
  const PhotoRepository();

  Future<List<Photo>> getPhotos();
  Future<void> addPhoto(Photo photo);
  Future<void> deletePhotos(String id);
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
  Future<void> addPhoto(Photo photo) async {
    await _db.insert(
      Photo.table,
      photo.toMap(),
    );
  }

  @override
  Future<void> deletePhotos(String id) async {
    await _db.delete(
      Photo.table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
