import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/CompanyService.dart';
import 'package:flutter_application_1/Services/AuthService.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

/// Tela para admin cadastrar sua empresa
class WidgetCadastroEmpresa extends StatefulWidget {
  final AuthResult authResult; // Dados do admin logado

  const WidgetCadastroEmpresa({
    Key? key,
    required this.authResult,
  }) : super(key: key);

  @override
  State<WidgetCadastroEmpresa> createState() => _WidgetCadastroEmpresaState();
}

class _WidgetCadastroEmpresaState extends State<WidgetCadastroEmpresa> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _companyService = CompanyService();
  bool _isLoading = false;

  // Máscara para CNPJ: 00.000.000/0000-00
  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<void> _cadastrarEmpresa() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final company = await _companyService.createCompany(
        name: _nomeController.text.trim(),
        cnpj: _cnpjController.text
            .replaceAll(RegExp(r'[^\d]'), ''), // Remove máscara
        adminUserId: widget.authResult.user.id!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Empresa "${company.name}" cadastrada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Voltar para dashboard ou navegar para adicionar funcionários
      Navigator.of(context).pop(company);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Empresa'),
        backgroundColor: const Color(0xFF0857C3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.business,
                size: 80,
                color: Color(0xFF0857C3),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cadastre sua empresa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Admin: ${widget.authResult.userName}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Empresa',
                  prefixIcon: Icon(Icons.business_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o nome da empresa'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cnpjController,
                keyboardType: TextInputType.number,
                inputFormatters: [_cnpjMask],
                decoration: const InputDecoration(
                  labelText: 'CNPJ (opcional)',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                  hintText: '00.000.000/0000-00',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final cnpjDigits = value.replaceAll(RegExp(r'[^\d]'), '');
                    if (cnpjDigits.length != 14) {
                      return 'CNPJ deve ter 14 dígitos';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0857C3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          _cadastrarEmpresa();
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Cadastrar Empresa',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
