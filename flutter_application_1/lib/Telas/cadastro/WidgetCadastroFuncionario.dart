import 'package:flutter/material.dart';
import 'package:flutter_application_1/Banco/entidades/Company.dart';
import 'package:flutter_application_1/Services/CompanyService.dart';
import 'package:flutter_application_1/Banco/DAO/CompanyDAO.dart';
import 'package:flutter_application_1/Telas/cadastro/WidgetListaFuncionarios.dart';

/// Tela para admin adicionar funcionário vinculado a uma empresa
class WidgetCadastroFuncionario extends StatefulWidget {
  final int adminUserId;

  const WidgetCadastroFuncionario({
    Key? key,
    required this.adminUserId,
  }) : super(key: key);

  @override
  State<WidgetCadastroFuncionario> createState() =>
      _WidgetCadastroFuncionarioState();
}

class _WidgetCadastroFuncionarioState extends State<WidgetCadastroFuncionario> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _companyService = CompanyService();
  final _companyDAO = CompanyDao();

  // Key para controlar o widget filho
  final _listaKey = GlobalKey();

  List<Company> _listCompanies = [];
  Company? _empresaSelecionada;
  bool _isLoading = false;
  bool _isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _carregarEmpresas();
  }

  Future<void> _carregarEmpresas() async {
    setState(() => _isLoadingCompanies = true);
    try {
      final companies = await _companyDAO.readAll();
      setState(() {
        _listCompanies = companies;
        if (companies.isNotEmpty) {
          _empresaSelecionada = companies.first;
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar empresas: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoadingCompanies = false);
    }
  }

  Future<void> _cadastrarFuncionario() async {
    if (!_formKey.currentState!.validate()) return;

    if (_empresaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma empresa'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final novoFuncionario = await _companyService.addEmployee(
        companyId: _empresaSelecionada!.id!,
        name: _nomeController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        password: _senhaController.text,
        requestingUserId: widget.adminUserId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Funcionário ${novoFuncionario.name} adicionado à ${_empresaSelecionada!.name}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpar campos
      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();

      // Atualizar lista filha
      (_listaKey.currentState as dynamic)?.recarregar();
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
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Funcionários'),
        backgroundColor: const Color(0xFF0857C3),
      ),
      body: _isLoadingCompanies
          ? const Center(child: CircularProgressIndicator())
          : _listCompanies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.business_outlined,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhuma empresa cadastrada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.add_business),
                        label: const Text('Cadastrar Empresa'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // ========== FORMULÁRIO ==========
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.white,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Adicionar Funcionário',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Dropdown de empresas
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFF0857C3)),
                                ),
                                child: DropdownButtonFormField<Company>(
                                  value: _empresaSelecionada,
                                  decoration: const InputDecoration(
                                    labelText: 'Empresa',
                                    prefixIcon: Icon(Icons.business,
                                        color: Color(0xFF0857C3)),
                                    border: InputBorder.none,
                                  ),
                                  items: _listCompanies.map((adminCompany) {
                                    return DropdownMenuItem<Company>(
                                      value: adminCompany,
                                      child: Text(adminCompany.name),
                                    );
                                  }).toList(),
                                  onChanged: (adminCompany) {
                                    setState(() =>
                                        _empresaSelecionada = adminCompany);
                                  },
                                  validator: (value) => value == null
                                      ? 'Selecione uma empresa'
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                  controller: _nomeController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome do funcionário',
                                    prefixIcon: Icon(Icons.person_outline),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty)
                                      return 'Informe o nome';
                                    return null;
                                  }),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty)
                                    return 'Informe o e-mail';
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value))
                                    return 'E-mail inválido';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                controller: _senhaController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Senha inicial',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(),
                                  helperText:
                                      'O funcionário poderá alterar depois',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Informe a senha';
                                  if (value.length < 6)
                                    return 'Mínimo 6 caracteres';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

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
                                  onPressed:
                                      _isLoading ? null : _cadastrarFuncionario,
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : const Text(
                                          'Adicionar Funcionário',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 1, thickness: 2),

                      // LISTA DE FUNCIONÁRIOS
                      if (_empresaSelecionada != null)
                        WidgetListaFuncionarios(
                          key: _listaKey,
                          companyId: _empresaSelecionada!.id!,
                          adminUserId: widget.adminUserId,
                        ),
                    ],
                  ),
                ),
    );
  }
}
