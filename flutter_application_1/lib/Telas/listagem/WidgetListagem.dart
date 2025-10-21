import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/Banco/entidades/Contract.dart';
import 'package:flutter_application_1/Banco/entidades/Partner.dart';
import 'package:flutter_application_1/Services/ContractService.dart';
import 'package:flutter_application_1/Banco/dao/PartnerDao.dart';

class WidgetListagem extends StatefulWidget {
  const WidgetListagem({Key? key}) : super(key: key);

  @override
  State<WidgetListagem> createState() => _WidgetListagemState();
}

class _WidgetListagemState extends State<WidgetListagem> {
  final ContractService _contractService = ContractService();
  final PartnerDao _partnerDao = PartnerDao();

  late Future<List<Contract>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _loadContracts();
  }

  void _loadContracts() {
    _contractsFuture = _contractService.readAllContracts();
  }

  Future<void> _deleteContract(String id) async {
    await _contractService.deleteContract(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contrato excluído com sucesso')),
    );
    setState(() => _loadContracts());
  }

  Future<List<Partner>> _getPartners(String contractId) async {
    return await _partnerDao.findByContract(contractId);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Contratos Analisados'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0857C3),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Contract>>(
        future: _contractsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum contrato encontrado.'));
          }

          final contracts = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contracts.length,
            itemBuilder: (context, index) {
              final contract = contracts[index];
              final bool isProcessed = contract.status == 'processed';
              final Color statusColor = isProcessed
                  ? Colors.green
                  : Colors.orange;
              final String statusText = isProcessed
                  ? 'Análise Concluída'
                  : 'Em Processamento';

              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Cabeçalho de status
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: statusColor,
                            size: 26,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            statusText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteContract(contract.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 🔹 Campos principais
                      if (contract.companyName != null)
                        _infoTile(
                          icon: Icons.business,
                          color: Colors.blueAccent,
                          title: contract.companyName!,
                          subtitle: 'Razão Social',
                        ),
                      if (contract.cnpj != null)
                        _infoTile(
                          icon: Icons.badge,
                          color: Colors.orange,
                          title: contract.cnpj!,
                          subtitle: 'CNPJ',
                        ),
                      if (contract.capitalSocial != null)
                        _infoTile(
                          icon: Icons.attach_money,
                          color: Colors.green,
                          title: currencyFormatter.format(
                            contract.capitalSocial,
                          ),
                          subtitle: 'Capital Social',
                        ),
                      if (contract.foundationDate != null)
                        _infoTile(
                          icon: Icons.calendar_today,
                          color: Colors.purple,
                          title: contract.foundationDate!,
                          subtitle: 'Data de Fundação',
                        ),
                      if (contract.address != null)
                        _infoTile(
                          icon: Icons.location_on,
                          color: Colors.pinkAccent,
                          title: contract.address!,
                          subtitle: 'Endereço',
                        ),

                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),

                      // 🔹 Sócios
                      const Text(
                        'Sócios Identificados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),

                      FutureBuilder<List<Partner>>(
                        future: _getPartners(contract.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Erro ao carregar sócios');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text(
                              'Nenhum sócio cadastrado',
                              style: TextStyle(color: Colors.grey),
                            );
                          }

                          final partners = snapshot.data!;
                          return Column(
                            children: partners
                                .map(
                                  (p) => _infoTile(
                                    icon: Icons.person,
                                    color: Colors.purple,
                                    title: p.name ?? 'Nome não informado',
                                    subtitle: p.role ?? 'Cargo',
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🔹 Método auxiliar para exibir ícone + título + subtítulo
  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
