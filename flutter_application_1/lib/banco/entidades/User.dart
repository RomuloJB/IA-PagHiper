class User {
  final String id;
  final String? name;
  final String? email;
  final String? createdAt;

  User({required this.id, this.name, this.email, this.createdAt});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'created_at': createdAt};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: map['created_at'],
    );
  }
}
