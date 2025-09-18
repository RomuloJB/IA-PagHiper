import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/BotaoGenerico/widget_botao.dart';
import 'package:flutter_application_1/Routes/rotas.dart';

class WidgetLogin extends StatelessWidget {
  const WidgetLogin({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entrar no sistema")),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "Usuário",
                hintText: "Digite o nome do usuário",
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Senha",
                hintText: "Digite sua senha",
              ),
            ),
            WidgetBotao(rota: Rotas.home, rotulo: "Entrar"),
          ],
        ),
      ),
    );
  }
}
