import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import 'photo.dart';

final class Invoice {
  Invoice({
    required this.id,
    required this.number,
    required this.template,
    required this.date,
    required this.dueDate,
    required this.bid,
    required this.cid,
    this.paymentDate = 0,
    this.paymentMethod = '',
    required this.tax,
    required this.signature,

    //
    this.business,
    this.client,
    this.items = const [],
    this.photos = const [],
  });

  final String id;
  final int number;
  int template;
  int date;
  int dueDate;
  int bid;
  int cid;
  int paymentDate;
  String paymentMethod;
  String tax;
  String signature;

  Business? business;
  Client? client;
  List<Item> items;
  List<Photo> photos;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number': number,
      'template': template,
      'date': date,
      'dueDate': dueDate,
      'bid': bid,
      'cid': cid,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
      'tax': tax,
      'signature': signature,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      number: map['number'],
      template: map['template'],
      date: map['date'],
      dueDate: map['dueDate'],
      bid: map['bid'],
      cid: map['cid'],
      paymentDate: map['paymentDate'],
      paymentMethod: map['paymentMethod'],
      tax: map['tax'],
      signature: map['signature'],
    );
  }

  static const table = 'invoices';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id TEXT,
      number INTEGER,
      template INTEGER,
      date INTEGER,
      dueDate INTEGER,
      bid INTEGER,
      cid INTEGER,
      paymentDate INTEGER,
      paymentMethod TEXT,
      tax TEXT,
      signature TEXT
    )
    ''';
}
