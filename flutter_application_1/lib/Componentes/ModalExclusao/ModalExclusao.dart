import 'package:flutter/material.dart';

class Modalexclusao extends StatelessWidget {
  final String? tabela, id, nome;
  final Future<void> Function()? onPressed;
  const Modalexclusao({
    Key? key,
    required this.tabela,
    required this.id,
    required this.nome,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_outlined, color: Colors.orange, size: 30),
          SizedBox(width: 10),
          Text(
            "Atenção",
            style: TextStyle(
              fontSize: 20,
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      contentPadding: EdgeInsets.all(20),

      titleTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      content: Text(
        this.tabela == "cliente"
            ? "Você realmente deseja excluir o cliente $nome?"
            : this.tabela == "produto"
            ? "Você realmente deseja excluir o produto $nome?"
            : this.tabela == "grupo_produto"
            ? "Você realmente deseja excluir o grupo de produto $nome?"
            : this.tabela == "servico"
            ? "Você realmente deseja excluir o serviço $nome?"
            : "Você realmente deseja excluir o serviço $nome",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            "Excluir",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
