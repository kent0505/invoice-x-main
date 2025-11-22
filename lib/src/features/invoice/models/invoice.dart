import '../../business/models/business.dart';
import '../../client/models/client.dart';
import '../../item/models/item.dart';
import 'photo.dart';

final class Invoice {
  Invoice({
    this.id = 0,
    required this.number,
    required this.template,
    required this.date,
    required this.dueDate,
    required this.businessID,
    required this.clientID,
    this.paymentDate = 0,
    required this.tax,
    this.paymentMethod = '',
    required this.imageSignature,
    required this.isEstimate,
    this.business,
    this.client,
    this.items = const [],
    this.photos = const [],
  });

  int id;
  int number;
  int template;
  int date;
  int dueDate;
  int businessID;
  int clientID;
  int paymentDate;
  String tax;
  String paymentMethod;
  String imageSignature;
  bool isEstimate;
  Business? business;
  Client? client;
  List<Item> items;
  List<Photo> photos;

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'template': template,
      'date': date,
      'dueDate': dueDate,
      'businessID': businessID,
      'clientID': clientID,
      'paymentDate': paymentDate,
      'tax': tax,
      'paymentMethod': paymentMethod,
      'imageSignature': imageSignature,
      'isEstimate': isEstimate ? 1 : 0,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      number: map['number'],
      template: map['template'],
      date: map['date'],
      dueDate: map['dueDate'],
      businessID: map['businessID'],
      clientID: map['clientID'],
      paymentDate: map['paymentDate'],
      tax: map['tax'],
      paymentMethod: map['paymentMethod'],
      imageSignature: map['imageSignature'],
      isEstimate: map['isEstimate'] == 1,
    );
  }

  static const table = 'invoices';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      number INTEGER,
      template INTEGER,
      date INTEGER,
      dueDate INTEGER,
      businessID INTEGER,
      clientID INTEGER,
      paymentDate INTEGER,
      tax TEXT,
      paymentMethod TEXT,
      imageSignature TEXT,
      isEstimate INTEGER
    )
    ''';
}
