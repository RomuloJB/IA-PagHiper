import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';

const Color kBackgroundColor = Color(0xFFF5F7FA);
const Color kPrimaryBlue = Color(0xFF1E88E5);
const Color kPrimaryGreen = Color(0xFF4CAF50);
const Color kTextColor = Color(0xFF212121);
const Color kCardBorderColor = Color(0xFFE0E0E0);
const List<Color> kChartColors = [
  kPrimaryBlue,
  kPrimaryGreen,
  Color(0xFFFF9800),
  Color(0xFFAB47BC),
  Color(0xFFB0BEC5),
];

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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard de Contratos'),
        backgroundColor: kPrimaryBlue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: contratos.isEmpty
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBlue))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _MetricCard(
                          label: "Total Contratos",
                          value: totalContratos.toString(),
                          color: kPrimaryBlue,
                        ),
                        _MetricCard(
                          label: "Processados",
                          value: totalProcessados.toString(),
                          color: kPrimaryGreen,
                        ),
                        _MetricCard(
                          label: "Falhas",
                          value: totalFalha.toString(),
                          color: Colors.redAccent,
                        ),
                        _MetricCard(
                          label: "Média Capital",
                          value: "R\$ ${mediaCapitalSocial.toStringAsFixed(2)}",
                          color: kPrimaryBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _SectionTitle(
                      title: "Evolução dos contratos processados (mês)",
                    ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
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
                                      color:
                                          kChartColors[entry.key %
                                              kChartColors.length],
                                      width: 14,
                                      borderRadius: BorderRadius.circular(4),
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
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: kTextColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: kTextColor,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawHorizontalLine: true,
                            horizontalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: kCardBorderColor,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(title: "Distribuição de regimes tributários"),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: regimeDistribuicao.isEmpty
                          ? const Center(
                              child: Text(
                                "Nenhum dado disponível",
                                style: TextStyle(color: kTextColor),
                              ),
                            )
                          : PieChart(
                              PieChartData(
                                sections: regimeDistribuicao.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) {
                                      final index = e.key;
                                      final entry = e.value;
                                      return PieChartSectionData(
                                        title: '',
                                        value: entry.value.toDouble(),
                                        color:
                                            kChartColors[index %
                                                kChartColors.length],
                                        radius: 60,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: regimeDistribuicao.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) {
                            final index = e.key;
                            final entry = e.value;
                            final color =
                                kChartColors[index % kChartColors.length];
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kTextColor,
                                  ),
                                ),
                              ],
                            );
                          })
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    _SectionTitle(title: "Distribuição por tipo societário"),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: tipoSocietarioDistribuicao.isEmpty
                          ? const Center(
                              child: Text(
                                "Nenhum dado disponível",
                                style: TextStyle(color: kTextColor),
                              ),
                            )
                          : PieChart(
                              PieChartData(
                                sections: tipoSocietarioDistribuicao.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) {
                                      final index = e.key;
                                      final entry = e.value;
                                      return PieChartSectionData(
                                        title: '',
                                        value: entry.value.toDouble(),
                                        color:
                                            kChartColors[index %
                                                kChartColors.length],
                                        radius: 60,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: tipoSocietarioDistribuicao.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) {
                            final index = e.key;
                            final entry = e.value;
                            final color =
                                kChartColors[index % kChartColors.length];
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kTextColor,
                                  ),
                                ),
                              ],
                            );
                          })
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(title: "Lista de contratos"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 16,
                        columns: const [
                          DataColumn(
                            label: Text(
                              "ID",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Empresa",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "CNPJ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Status",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Upload",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Processamento",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Ações",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                        ],
                        rows: contratos
                            .map(
                              (c) => DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      c.id,
                                      style: const TextStyle(color: kTextColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      c.companyName,
                                      style: const TextStyle(color: kTextColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      c.cnpj,
                                      style: const TextStyle(color: kTextColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      c.status,
                                      style: TextStyle(
                                        color: c.status == 'processed'
                                            ? kPrimaryGreen
                                            : c.status == 'failed'
                                            ? Colors.redAccent
                                            : kPrimaryBlue,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      c.uploadedAt,
                                      style: const TextStyle(color: kTextColor),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      c.processedAt ?? "-",
                                      style: const TextStyle(color: kTextColor),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.visibility,
                                            color: kPrimaryBlue,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
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
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 80),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kCardBorderColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: kTextColor),
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
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kPrimaryBlue,
          ),
        ),
      ),
    );
  }
}
