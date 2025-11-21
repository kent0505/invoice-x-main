class Business {
  Business({
    this.id = 0,
    required this.name,
    required this.businessName,
    required this.address,
    required this.phone,
    required this.email,
    required this.bank,
    required this.swift,
    required this.iban,
    required this.accountNo,
    required this.vat,
    required this.imageLogo,
    required this.imageSignature,
  });

  int id;
  String name;
  String businessName;
  String address;
  String phone;
  String email;
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
      'businessName': businessName,
      'address': address,
      'phone': phone,
      'email': email,
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
      businessName: map['businessName'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
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
      businessName TEXT,
      address TEXT,
      phone TEXT,
      email TEXT,
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
