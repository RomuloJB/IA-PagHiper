import 'package:flutter/material.dart';
import 'package:flutter_application_1/Banco/entidades/User.dart';
import 'package:flutter_application_1/Banco/DAO/UserDAO.dart';
import 'package:flutter_application_1/componentes/botaoGenerico/BotaoGenerico.dart';

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
  final _userDao = UserDao();

  Future<void> _salvarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final novoUsuario = User(
      name: _nomeController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      password: _senhaController.text,
      createdAt: DateTime.now().toIso8601String(),
    );

    final newId = await _userDao.create(novoUsuario);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário cadastrado com sucesso! ID: $newId')),
    );

    _formKey.currentState!.reset();
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _confirmarSenhaController.clear();
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
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o nome'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Informe o e-mail';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return 'E-mail inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a senha';
                  if (value.length < 6)
                    return 'A senha deve ter pelo menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Confirme sua senha';
                  if (value != _senhaController.text)
                    return 'As senhas não coincidem';
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
