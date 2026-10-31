class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  bool isFavorite;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isFavorite = false,
  });

  // JSON API -> Post object
  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as int,
    userId: json['userId'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
  );

  // Post object -> Map (DB row)
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': userId,
    'title': title,
    'body': body,
    'isFavorite': isFavorite ? 1 : 0,
  };

  // Map (DB row) -> Post object
  factory Post.fromMap(Map<String, Object?> map) => Post(
    id: map['id'] as int,
    userId: map['userId'] as int,
    title: map['title'] as String,
    body: map['body'] as String,
    isFavorite: (map['isFavorite'] as int) == 1,
  );
}
