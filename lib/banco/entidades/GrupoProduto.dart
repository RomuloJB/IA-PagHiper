class GrupoProduto {
  final int? id_grupo_produto;
  final String nome;

  GrupoProduto({this.id_grupo_produto, required this.nome});

  @override
  String toString() =>
      'GrupoProduto(id_grupo_produto: $id_grupo_produto, nome: $nome)';

  Map<String, dynamic> toMap() {
    return {'id_grupo_produto': id_grupo_produto, 'nome': nome};
  }

  factory GrupoProduto.fromMap(Map<String, dynamic> map) {
    return GrupoProduto(
      id_grupo_produto: map['id_grupo_produto'],
      nome: map['nome'],
    );
  }
}
