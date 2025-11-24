final class Item {
  Item({
    this.id = 0,
    required this.title,
    required this.type,
    required this.price,
    required this.discountPrice,
    this.invoiceID = 0,
  });

  int id;
  String title;
  String type;
  String price;
  String discountPrice;
  int invoiceID;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'price': price,
      'discountPrice': discountPrice,
      'invoiceID': invoiceID,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      invoiceID: map['invoiceID'],
    );
  }

  static const table = 'items';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      type TEXT,
      price TEXT,
      discountPrice TEXT,
      invoiceID INTEGER
    )
    ''';
}
