import 'package:flutter/material.dart';
import 'package:flutter_application_1/Banco/entidades/Contract.dart';
import 'package:intl/intl.dart';

class RecentContractsWidget extends StatelessWidget {
  final List<Contract> contracts;
  final bool isLoading;
  final VoidCallback? onViewAll;

  const RecentContractsWidget({
    Key? key,
    required this.contracts,
    this.isLoading = false,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (contracts.isEmpty) {
      return _buildEmptyState();
    }

    final recentContracts = contracts.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Contratos Recentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            if (contracts.length > 5 && onViewAll != null)
              TextButton.icon(
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('Ver Todos'),
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0857C3),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0857C3).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Empresa',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF0857C3),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'CNPJ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF0857C3),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Data',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF0857C3),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF0857C3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentContracts.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final contract = recentContracts[index];
                  return _buildContractRow(contract);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContractRow(Contract contract) {
    final dateFormat = DateFormat('dd/MM/yy HH:mm');
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    switch (contract.status) {
      case 'processed':
        statusColor = const Color(0xFF24d17a);
        statusIcon = Icons.check_circle;
        statusLabel = 'OK';
        break;
      case 'failed':
        statusColor = Colors.redAccent;
        statusIcon = Icons.error;
        statusLabel = 'Erro';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusLabel = 'Pendente';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusLabel = 'N/A';
    }

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contract.companyName ?? contract.filename,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (contract.companyName != null &&
                      contract.filename != contract.companyName)
                    Text(
                      contract.filename,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                contract.cnpj ?? '-',
                style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                dateFormat.format(DateTime.parse(contract.uploadedAt)),
                style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                children: [
                  Icon(statusIcon, size: 16, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum contrato encontrado',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Envie seu primeiro contrato para análise',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
