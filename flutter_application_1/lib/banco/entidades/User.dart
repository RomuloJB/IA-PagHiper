class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? createdAt;

  const User({this.id, this.name, this.email, this.password, this.createdAt});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] is int ? map['id'] as int : int.tryParse('${map['id']}'),
      name: map['name'] as String?,
      email: map['email'] as String?,
      password: map['password'] as String?,
      createdAt: map['created_at'] as String?,
    );
  }
}
