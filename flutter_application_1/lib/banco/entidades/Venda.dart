class Venda {
  int? idVenda;
  int? clienteId;
  DateTime? dataVenda;
  double? valorTotal;
  String? descricao;

  Venda({
    this.idVenda,
    this.clienteId,
    this.dataVenda,
    this.valorTotal,
    this.descricao,
  });

  Venda.fromMap(Map<String, dynamic> map) {
    idVenda = map['id_venda'];
    clienteId = map['cliente_id'];
    dataVenda = DateTime.fromMillisecondsSinceEpoch(map['data_venda'] as int);
    valorTotal = map['valor_total'];
    descricao = map['descricao'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id_venda': idVenda,
      'cliente_id': clienteId,
      'data_venda': dataVenda?.millisecondsSinceEpoch,
      'valor_total': valorTotal,
      'descricao': descricao,
    };
  }
}
