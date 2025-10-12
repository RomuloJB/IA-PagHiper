import 'package:flutter/material.dart';
import 'package:flutter_application_1/Componentes/Cards/MetricCard.dart';

class DashboardMetricsSection extends StatelessWidget {
  final int totalContratos;
  final int totalProcessados;
  final int totalFalhas;
  final double mediaCapitalSocial;
  final bool isLoading;

  const DashboardMetricsSection({
    Key? key,
    required this.totalContratos,
    required this.totalProcessados,
    required this.totalFalhas,
    required this.mediaCapitalSocial,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visão Geral',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            MetricCard(
              label: "Total de Contratos",
              value: totalContratos.toString(),
              color: const Color(0xFF0857C3),
              icon: Icons.description,
            ),
            MetricCard(
              label: "Processados",
              value: totalProcessados.toString(),
              color: const Color(0xFF24d17a),
              icon: Icons.check_circle,
            ),
            MetricCard(
              label: "Falhas",
              value: totalFalhas.toString(),
              color: Colors.redAccent,
              icon: Icons.error,
            ),
            MetricCard(
              label: "Média Capital",
              value: "R\$ ${mediaCapitalSocial.toStringAsFixed(0)}",
              color: const Color(0xFFFF9800),
              icon: Icons.trending_up,
            ),
          ],
        ),
      ],
    );
  }
}
