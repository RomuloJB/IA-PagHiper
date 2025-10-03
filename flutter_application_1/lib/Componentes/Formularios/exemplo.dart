import 'package:flutter/material.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool lembrarMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de e-mail
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de senha
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox lembrar-me
            Row(
              children: [
                Checkbox(
                  value: lembrarMe,
                  activeColor: const Color(0xFF24D17A), // verde do checkbox
                  onChanged: (value) {
                    setState(() {
                      lembrarMe = value ?? false;
                    });
                  },
                ),
                const Text('Lembrar-me'),
              ],
            ),

            const SizedBox(height: 16),

            // Botão Entrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF24D17A), // verde do botão
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Ação do botão
                },
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Esqueci minha senha
            TextButton(
              onPressed: () {
                // Ação do link
              },
              child: const Text(
                'Esqueci minha senha',
                style: TextStyle(
                  color: Color(0xFF0860DB), // azul do link
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
