class Servico {
  int? id_servico;
  final String? nome;
  final double? preco;

  Servico({this.id_servico, required this.nome, required this.preco});
  Map<String, dynamic> toMap() {
    return {'id_servico': id_servico, 'nome': nome, 'preco': preco};
  }

  factory Servico.fromMap(Map<String, dynamic> map) {
    return Servico(
      id_servico: map['id_servico'],
      nome: map['nome'],
      preco: map['preco'],
    );
  }
}
