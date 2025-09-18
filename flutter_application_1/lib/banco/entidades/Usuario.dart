class Usuario {
  int? id;
  String? nome;
  String? senha;
  Usuario({required this.nome, required this.senha, required id});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'senha': senha};
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(id: map['id'], nome: map['nome'], senha: map['senha']);
  }
}
