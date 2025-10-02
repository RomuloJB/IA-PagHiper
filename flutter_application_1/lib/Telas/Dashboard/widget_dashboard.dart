import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

class DashboardContrato {
  final String id;
  final String companyName;
  final String cnpj;
  final String status;
  final String uploadedAt;
  final String? processedAt;
  final double capitalSocial;
  final String corporateRegime;
  final String societyType;

  DashboardContrato({
    required this.id,
    required this.companyName,
    required this.cnpj,
    required this.status,
    required this.uploadedAt,
    required this.processedAt,
    required this.capitalSocial,
    required this.corporateRegime,
    required this.societyType,
  });

  factory DashboardContrato.fromJson(Map<String, dynamic> json) {
    return DashboardContrato(
      id: json['id'],
      companyName: json['company_name'],
      cnpj: json['cnpj'],
      status: json['status'],
      uploadedAt: json['uploaded_at'],
      processedAt: json['processed_at'],
      capitalSocial: (json['capital_social'] ?? 0).toDouble(),
      corporateRegime: json['corporate_regime'] ?? "",
      societyType: json['society_type'] ?? "",
    );
  }
}

class WidgetDashboard extends StatefulWidget {
  const WidgetDashboard({super.key});

  @override
  State<WidgetDashboard> createState() => _WidgetDashboardState();
}

class _WidgetDashboardState extends State<WidgetDashboard> {
  List<DashboardContrato> contratos = [];

  int totalContratos = 0;
  int totalProcessados = 0;
  int totalFalha = 0;
  double mediaCapitalSocial = 0;

  Map<String, int> contratosPorMes = {};
  Map<String, int> regimeDistribuicao = {};
  Map<String, int> tipoSocietarioDistribuicao = {};

  @override
  void initState() {
    super.initState();
    carregarMock();
  }

  Future<void> carregarMock() async {
    final String response = await rootBundle.loadString(
      'assets/contratos.json',
    );
    final List<dynamic> data = json.decode(response);

    contratos = data.map((e) => DashboardContrato.fromJson(e)).toList();
    calcularIndicadores();
    setState(() {});
  }

  void calcularIndicadores() {
    totalContratos = contratos.length;
    totalProcessados = contratos.where((c) => c.status == 'processed').length;
    totalFalha = contratos.where((c) => c.status == 'failed').length;
    mediaCapitalSocial = contratos.isNotEmpty
        ? contratos.map((c) => c.capitalSocial).reduce((a, b) => a + b) /
              contratos.length
        : 0;

    contratosPorMes.clear();
    for (var c in contratos) {
      if (c.processedAt != null) {
        final mes = c.processedAt!.substring(0, 7);
        contratosPorMes[mes] = (contratosPorMes[mes] ?? 0) + 1;
      }
    }

    regimeDistribuicao.clear();
    for (var c in contratos) {
      regimeDistribuicao[c.corporateRegime] =
          (regimeDistribuicao[c.corporateRegime] ?? 0) + 1;
    }

    tipoSocietarioDistribuicao.clear();
    for (var c in contratos) {
      tipoSocietarioDistribuicao[c.societyType] =
          (tipoSocietarioDistribuicao[c.societyType] ?? 0) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Contratos')),
      body: contratos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Cards de métricas globais - simples
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MetricCard(
                          label: "Total Contratos",
                          value: totalContratos.toString(),
                        ),
                        _MetricCard(
                          label: "Processados",
                          value: totalProcessados.toString(),
                        ),
                        _MetricCard(
                          label: "Falhas",
                          value: totalFalha.toString(),
                        ),
                        _MetricCard(
                          label: "Média Capital",
                          value: "R\$ ${mediaCapitalSocial.toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: "Evolução dos contratos processados (mês)",
                    ),
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (contratosPorMes.values.isNotEmpty)
                              ? contratosPorMes.values
                                        .reduce((a, b) => a > b ? a : b)
                                        .toDouble() +
                                    2
                              : 10,
                          barGroups: contratosPorMes.entries
                              .toList()
                              .asMap()
                              .entries
                              .map(
                                (entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.value.toDouble(),
                                      color: Theme.of(context).primaryColor,
                                      width: 14,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx >= contratosPorMes.keys.length)
                                    return const SizedBox();
                                  return Text(
                                    contratosPorMes.keys.elementAt(idx),
                                    style: const TextStyle(fontSize: 11),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(title: "Distribuição de regimes tributários"),
                    SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: regimeDistribuicao.entries
                              .map(
                                (e) => PieChartSectionData(
                                  title: e.key,
                                  value: e.value.toDouble(),
                                  color:
                                      Colors.blueGrey[(regimeDistribuicao.keys
                                                  .toList()
                                                  .indexOf(e.key) +
                                              1) *
                                          100],
                                  titleStyle: const TextStyle(fontSize: 11),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _SectionTitle(title: "Distribuição por tipo societário"),
                    SizedBox(
                      height: 150,
                      child: PieChart(
                        PieChartData(
                          sections: tipoSocietarioDistribuicao.entries
                              .map(
                                (e) => PieChartSectionData(
                                  title: e.key,
                                  value: e.value.toDouble(),
                                  color:
                                      Colors.grey[(tipoSocietarioDistribuicao
                                                  .keys
                                                  .toList()
                                                  .indexOf(e.key) +
                                              1) *
                                          100],
                                  titleStyle: const TextStyle(fontSize: 11),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(title: "Lista de contratos"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Empresa")),
                          DataColumn(label: Text("CNPJ")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Upload")),
                          DataColumn(label: Text("Processamento")),
                          DataColumn(label: Text("Ações")),
                        ],
                        rows: contratos
                            .map(
                              (c) => DataRow(
                                cells: [
                                  DataCell(Text(c.id)),
                                  DataCell(Text(c.companyName)),
                                  DataCell(Text(c.cnpj)),
                                  DataCell(Text(c.status)),
                                  DataCell(Text(c.uploadedAt)),
                                  DataCell(Text(c.processedAt ?? "-")),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.visibility),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 80),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // ADICIONADO para evitar overflow
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              // ADICIONADO para evitar overflow
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
