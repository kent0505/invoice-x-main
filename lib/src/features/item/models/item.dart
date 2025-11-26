final class Item {
  Item({
    this.id = 0,
    required this.title,
    required this.type,
    required this.price,
    required this.discountPrice,
    this.iid = 0,
  });

  int id;
  String title;
  String type;
  String price;
  String discountPrice;
  int iid;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'price': price,
      'discountPrice': discountPrice,
      'iid': iid,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      price: map['price'],
      discountPrice: map['discountPrice'],
      iid: map['iid'],
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
      iid INTEGER
    )
    ''';
}
