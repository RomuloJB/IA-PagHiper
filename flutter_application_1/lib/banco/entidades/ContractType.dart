class ContractType {
  final int? id;
  final String name;

  ContractType({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory ContractType.fromMap(Map<String, dynamic> map) {
    return ContractType(id: map['id'], name: map['name']);
  }
}
