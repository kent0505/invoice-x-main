import 'package:sqflite/sqflite.dart';

import '../models/client.dart';

abstract interface class ClientRepository {
  const ClientRepository();

  Future<List<Client>> getClients();
  Future<void> addClient(Client client);
  Future<void> editClient(Client client);
  Future<void> deleteClient(Client client);
}

final class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl({required Database db}) : _db = db;

  final Database _db;

  @override
  Future<List<Client>> getClients() async {
    final maps = await _db.query(Client.table);
    return maps.map((map) {
      return Client.fromMap(map);
    }).toList();
  }

  @override
  Future<void> addClient(Client client) async {
    await _db.insert(
      Client.table,
      client.toMap(),
    );
  }

  @override
  Future<void> editClient(Client client) async {
    await _db.update(
      Client.table,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  @override
  Future<void> deleteClient(Client client) async {
    await _db.delete(
      Client.table,
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }
}
