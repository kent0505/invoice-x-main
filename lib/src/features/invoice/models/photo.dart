final class Photo {
  Photo({
    this.id = 0,
    required this.path,
  });

  int id;
  String path;

  Map<String, dynamic> toMap() {
    return {
      'path': path,
    };
  }

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      path: map['path'],
    );
  }

  static const table = 'photos';
  static const create = '''
    CREATE TABLE IF NOT EXISTS $table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path TEXT
    )
    ''';
}
