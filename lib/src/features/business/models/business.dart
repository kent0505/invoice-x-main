final class Business {
  Business({
    this.id = 0,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.bank = '',
    this.swift = '',
    this.iban = '',
    this.accountNo = '',
    this.vat = '',
    this.imageLogo = '',
    this.imageSignature = '',
  });

  int id;
  String name;
  String email;
  String phone;
  String address;
  String bank;
  String swift;
  String iban;
  String accountNo;
  String vat;
  String imageLogo;
  String imageSignature;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'bank': bank,
      'swift': swift,
      'iban': iban,
      'accountNo': accountNo,
      'vat': vat,
      'imageLogo': imageLogo,
      'imageSignature': imageSignature,
    };
  }

  factory Business.fromMap(Map<String, dynamic> map) {
    return Business(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      bank: map['bank'],
      swift: map['swift'],
      iban: map['iban'],
      accountNo: map['accountNo'],
      vat: map['vat'],
      imageLogo: map['imageLogo'],
      imageSignature: map['imageSignature'],
    );
  }

  static const table = 'business';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      phone TEXT,
      address TEXT,
      bank TEXT,
      swift TEXT,
      iban TEXT,
      accountNo TEXT,
      vat TEXT,
      imageLogo TEXT,
      imageSignature TEXT
    )
    ''';
}
