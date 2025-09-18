import 'package:barber_shop/Banco/entidades/GrupoProduto.dart';

class Produto {
  int? id_produto;
  String nome;
  double valor_unitario;
  double percentual_lucro;
  double valor_venda;
  GrupoProduto grupo_produto;

  Produto({
    this.id_produto,
    required this.nome,
    required this.valor_unitario,
    required this.percentual_lucro,
    required this.valor_venda,
    required this.grupo_produto,
  });

  @override
  String toString() {
    return 'Produto{id_produto: $id_produto, nome: $nome, valor_unitario: $valor_unitario, percentual_lucro: $percentual_lucro, valor_venda: $valor_venda, grupo_produto: $grupo_produto}';
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id_produto: map['id_produto'],
      nome: map['nome'],
      valor_unitario:
          map['valor_unitario'] is int
              ? (map['valor_unitario'] as int).toDouble()
              : map['valor_unitario'],
      percentual_lucro:
          map['percentual_lucro'] is int
              ? (map['percentual_lucro'] as int).toDouble()
              : map['percentual_lucro'],
      valor_venda:
          map['valor_venda'] is int
              ? (map['valor_venda'] as int).toDouble()
              : map['valor_venda'],
      grupo_produto:
          map['grupo_produto'] is Map<String, dynamic>
              ? GrupoProduto.fromMap(map['grupo_produto'])
              : GrupoProduto.fromMap({
                'id_grupo_produto': map['id_grupo_produto'],
                'nome': map['nome_grupo_produto'],
              }),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_produto': id_produto,
      'nome': nome,
      'valor_unitario': valor_unitario,
      'percentual_lucro': percentual_lucro,
      'valor_venda': valor_venda,
      'grupo_produto': grupo_produto.toMap(),
    };
  }
}
