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

  // Indicadores
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

    // Evolução de contratos processados por mês
    contratosPorMes.clear();
    for (var c in contratos) {
      if (c.processedAt != null) {
        final mes = c.processedAt!.substring(0, 7); // yyyy-MM
        contratosPorMes[mes] = (contratosPorMes[mes] ?? 0) + 1;
      }
    }

    // Distribuição de regimes tributários
    regimeDistribuicao.clear();
    for (var c in contratos) {
      regimeDistribuicao[c.corporateRegime] =
          (regimeDistribuicao[c.corporateRegime] ?? 0) + 1;
    }

    // Distribuição por tipo societário
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
                    // Cards de métricas globais
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    const SizedBox(height: 30),

                    // Gráfico evolução contratos processados por mês
                    _SectionTitle(
                      title: "Evolução dos contratos processados (mês)",
                    ),
                    SizedBox(
                      height: 250,
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
                                      color: Colors.blue,
                                      width: 18,
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
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Distribuição de regimes tributários (pizza)
                    _SectionTitle(title: "Distribuição de regimes tributários"),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: regimeDistribuicao.entries
                              .map(
                                (e) => PieChartSectionData(
                                  title: e.key,
                                  value: e.value.toDouble(),
                                  color:
                                      Colors.primaries[regimeDistribuicao.keys
                                              .toList()
                                              .indexOf(e.key) %
                                          Colors.primaries.length],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Distribuição por tipo societário (pizza)
                    _SectionTitle(title: "Distribuição por tipo societário"),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: tipoSocietarioDistribuicao.entries
                              .map(
                                (e) => PieChartSectionData(
                                  title: e.key,
                                  value: e.value.toDouble(),
                                  color:
                                      Colors.accents[tipoSocietarioDistribuicao
                                              .keys
                                              .toList()
                                              .indexOf(e.key) %
                                          Colors.accents.length],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tabela/lista de contratos
                    _SectionTitle(title: "Lista de contratos"),
                    DataTable(
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
                                        onPressed: () {
                                          // Exibir detalhes
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          // Excluir ação (simulação)
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Widgets auxiliares
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 120,
        height: 70,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(fontSize: 13)),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
