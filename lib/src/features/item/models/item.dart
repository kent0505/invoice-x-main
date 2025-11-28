final class Item {
  Item({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.discount,
    this.iid = '',
  });

  final String id;
  String title;
  String type;
  String price;
  String discount;
  String iid;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'price': price,
      'discount': discount,
      'iid': iid,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      price: map['price'],
      discount: map['discount'],
      iid: map['iid'],
    );
  }

  static const table = 'items';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id TEXT,
      title TEXT,
      type TEXT,
      price TEXT,
      discount TEXT,
      iid INTEGER
    )
    ''';
}
