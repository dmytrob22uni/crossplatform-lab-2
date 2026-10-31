class User {
  final int id;
  final String name;
  final String email;
  final String city;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
  });

  // JSON API -> User object
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    city: (json['address'] as Map<String, dynamic>)['city'] as String,
  );

  // User object -> Map (DB row)
  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'city': city,
  };

  // Map (DB row) -> User object
  factory User.fromMap(Map<String, Object?> map) => User(
    id: map['id'] as int,
    name: map['name'] as String,
    email: map['email'] as String,
    city: map['city'] as String,
  );
}
