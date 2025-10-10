import 'package:flutter/material.dart';
import 'package:flutter_application_1/banco/entidades/User.dart';
import 'package:flutter_application_1/componentes/botaoGenerico/BotaoGenerico.dart';
import 'package:uuid/uuid.dart';

class WidgetCadastro extends StatefulWidget {
  const WidgetCadastro({Key? key}) : super(key: key);

  @override
  State<WidgetCadastro> createState() => _WidgetCadastroState();
}

class _WidgetCadastroState extends State<WidgetCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _salvarUsuario() {
    if (_formKey.currentState!.validate()) {
      final novoUsuario = User(
        id: const Uuid().v4(),
        name: _nomeController.text,
        email: _emailController.text,
        password: _senhaController.text,
        createdAt: DateTime.now().toIso8601String(),
      );

      // 🔹 Aqui futuramente entra o DAO (ex: userDao.insertUser(novoUsuario))
      print('Usuário cadastrado: ${novoUsuario.toMap()}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

      _formKey.currentState!.reset();
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo e-mail
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo senha
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Campo confirmar senha
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != _senhaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              BotaoGenerico(text: 'Cadastrar', onPressed: _salvarUsuario),
            ],
          ),
        ),
      ),
    );
  }
}
