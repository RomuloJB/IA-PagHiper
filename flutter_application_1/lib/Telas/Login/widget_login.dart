import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/Formularios/form_login.dart';
import 'package:flutter_application_1/Routes/rotas.dart';

class WidgetLogin extends StatelessWidget {
  const WidgetLogin({super.key});

  Future<void> _onSubmit(
    BuildContext context,
    String email,
    String password,
    bool rememberMe,
  ) async {
    // TODO: substitua pela sua lógica real de autenticação
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Preencha e-mail e senha.');
    }

    // Exemplo: autenticação "ok" → navega para a Home
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(Rotas.home);
    }
  }

  void _onForgotPassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar senha'),
        content: const Text(
          'Enviamos um link de recuperação para o seu e-mail (exemplo).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IA PagHiper')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: LoginForm(
              onSubmit: (email, password, rememberMe) =>
                  _onSubmit(context, email, password, rememberMe),
              onForgotPassword: () => _onForgotPassword(context),
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
        ),
      ),
    );
  }
}
