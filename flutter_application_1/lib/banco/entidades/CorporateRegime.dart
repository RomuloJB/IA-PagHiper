class CorporateRegime {
  final int? id;
  final String name;

  CorporateRegime({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory CorporateRegime.fromMap(Map<String, dynamic> map) {
    return CorporateRegime(id: map['id'], name: map['name']);
  }
}
