class Client {
  Client({
    this.id = 0,
    required this.billTo,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  int id;
  String billTo;
  String name;
  String phone;
  String email;
  String address;

  Map<String, dynamic> toMap() {
    return {
      'billTo': billTo,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      billTo: map['billTo'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
    );
  }

  static const table = 'clients';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      billTo TEXT,
      name TEXT,
      phone TEXT,
      email TEXT,
      address TEXT
    )
    ''';
}
