final class Photo {
  Photo({
    this.id = 0,
    required this.path,
    this.iid = 0,
  });

  int id = 0;
  String path;
  int iid;

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'iid': iid,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      path: map['path'],
      iid: map['iid'],
    );
  }

  static const table = 'photos';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT,
      iid INTEGER
    )
    ''';
}
