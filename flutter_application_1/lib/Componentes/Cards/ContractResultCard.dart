import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractResultCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onAnalyzeAnother;
  final VoidCallback onGoToDashboard;

  const ContractResultCard({
    Key? key,
    required this.data,
    required this.onAnalyzeAnother,
    required this.onGoToDashboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final partners = data['partners'] as List;
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 3,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF24d17a),
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Análise Concluída',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 1),
                _buildInfoTile(
                  icon: Icons.business,
                  iconColor: const Color(0xFF0857C3),
                  title: data['company_name'] ?? 'Não informado',
                  subtitle: 'Razão Social',
                ),
                _buildInfoTile(
                  icon: Icons.pin,
                  iconColor: const Color(0xFFFF9800),
                  title: data['cnpj'] ?? 'Não informado',
                  subtitle: 'CNPJ',
                ),
                _buildInfoTile(
                  icon: Icons.attach_money,
                  iconColor: const Color(0xFF24d17a),
                  title: currencyFormatter.format(data['capital_social'] ?? 0),
                  subtitle: 'Capital Social',
                ),
                if (data['foundation_date'] != null)
                  _buildInfoTile(
                    icon: Icons.calendar_today,
                    iconColor: const Color(0xFFAB47BC),
                    title: data['foundation_date'],
                    subtitle: 'Data de Fundação',
                  ),
                if (data['address'] != null)
                  _buildInfoTile(
                    icon: Icons.location_on,
                    iconColor: const Color(0xFFE91E63),
                    title: data['address'],
                    subtitle: 'Endereço',
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Sócios Identificados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                ...partners.map(
                  (partner) => _buildInfoTile(
                    icon: Icons.person,
                    iconColor: const Color(0xFFAB47BC),
                    title: partner['name'],
                    subtitle: partner['role'] ?? 'Sócio',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Analisar Outro'),
            onPressed: onAnalyzeAnother,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0857C3),
              foregroundColor: Colors.white,
              minimumSize: const Size(300, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
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
