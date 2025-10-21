class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String role; // 'admin' ou 'user'
  final int? companyId;
  final String? createdAt;

  const User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role = 'user', // padrão: usuário comum
    this.companyId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'company_id': companyId,
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
      role: (map['role'] as String?) ?? 'user',
      companyId: map['company_id'] is int ? map['company_id'] as int : int.tryParse('${map['company_id'] ?? ''}'),
      createdAt: map['created_at'] as String?,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? role,
    int? companyId,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}