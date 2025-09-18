class SocietyType {
  final int? id;
  final String name;

  SocietyType({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory SocietyType.fromMap(Map<String, dynamic> map) {
    return SocietyType(id: map['id'], name: map['name']);
  }
}
