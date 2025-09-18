class VendaItem {
  int? idVendaItem;
  int? idVenda;
  int? idProduto;
  int? quantidade;
  double? valorTotal;

  VendaItem({
    this.idVendaItem,
    this.idVenda,
    this.idProduto,
    this.quantidade,
    this.valorTotal,
  });
  VendaItem.fromMap(Map<String, dynamic> map) {
    idVendaItem = map['id_venda_item'];
    idVenda = map['id_venda'];
    idProduto = map['id_produto'];
    quantidade = map['quantidade'];
    valorTotal = map['valor_total'];
  }
  Map<String, dynamic> toMap() {
    return {
      'id_venda_item': idVendaItem,
      'id_venda': idVenda,
      'id_produto': idProduto,
      'quantidade': quantidade,
      'valor_total': valorTotal,
    };
  }
}
