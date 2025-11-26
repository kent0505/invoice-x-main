final class Photo {
  Photo({
    required this.id,
    required this.path,
  });

  final String id;
  final String path;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      id TEXT,
      path TEXT
    )
    ''';
}
