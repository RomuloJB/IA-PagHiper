class Cliente {
  int? id;
  String? nome;
  String? sobrenome;
  String? celular;

  Cliente({
    required this.nome,
    required this.sobrenome,
    required this.celular,
    this.id,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'sobrenome': sobrenome, 'celular': celular};
  }

  // Converter de Map (para recuperar do banco)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      celular: map['celular'],
    );
  }
}
