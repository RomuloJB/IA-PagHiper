class User {
  final String id;
  final String? name;
  final String? email;
  final String? password;
  final String? createdAt;

  User({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      createdAt: map['created_at'],
    );
  }
}
