import 'package:flutter/material.dart';
import '../components/form/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _fakeLogin(
    BuildContext context,
    String email,
    String password,
    bool rememberMe,
  ) async {
    // Substitua esta lógica pela sua autenticação real
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Exemplo de validação simples
    const demoEmail = 'demo@exemplo.com';
    const demoPassword = '123456';

    if (email != demoEmail || password != demoPassword) {
      throw Exception(
        'Credenciais inválidas. Use demo@exemplo.com / 123456 para testar.',
      );
    }

    // Em caso de sucesso, você pode navegar para a home:
    // if (context.mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onForgotPassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar senha'),
        content: const Text(
          'Link de recuperação enviado para o seu e-mail (exemplo).',
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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              cs.primaryContainer.withOpacity(0.8),
              cs.secondaryContainer.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cabeçalho estilizado
                      Icon(Icons.lock_outline, size: 56, color: cs.primary),
                      const SizedBox(height: 12),
                      Text(
                        'Bem-vindo(a)',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Entre para continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Formulário de Login
                      LoginForm(
                        onSubmit: (email, password, rememberMe) =>
                            _fakeLogin(context, email, password, rememberMe),
                        onForgotPassword: () => _onForgotPassword(context),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),

                      const SizedBox(height: 16),
                      // Rodapé com link de cadastro (exemplo)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Não tem conta?'),
                          TextButton(
                            onPressed: () {
                              // Navigator.of(context).pushNamed('/register');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Navegar para a página de cadastro (exemplo)',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Cadastre-se'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
