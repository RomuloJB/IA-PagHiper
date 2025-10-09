import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const Color kBackgroundColor = Color(0xFFF5F7FA);
const Color kPrimaryBlue = Color(0xFF0857C3);
const Color kPrimaryGreen = Color(0xFF24d17a);
const Color kTextColor = Color(0xFF212121);
const Color kCardBorderColor = Color(0xFFE0E0E0);

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
  final List<Partner> partners;

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
    required this.partners,
  });

  factory DashboardContrato.fromJson(Map<String, dynamic> json) {
    return DashboardContrato(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      cnpj: json['cnpj']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      uploadedAt: json['uploaded_at']?.toString() ?? '',
      processedAt: json['processed_at']?.toString(),
      capitalSocial: (json['capital_social'] is num
          ? json['capital_social'].toDouble()
          : 0.0),
      corporateRegime: json['corporate_regime']?.toString() ?? '',
      societyType: json['society_type']?.toString() ?? '',
      partners:
          (json['partners'] as List<dynamic>?)
              ?.map((p) => Partner.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Partner {
  final String name;
  final String cpfCnpj;
  final String role;
  final double quotaPercent;
  final String address;

  Partner({
    required this.name,
    required this.cpfCnpj,
    required this.role,
    required this.quotaPercent,
    required this.address,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      name: json['name']?.toString() ?? '',
      cpfCnpj: json['cpf_cnpj']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      quotaPercent: (json['quota_percent'] is num
          ? json['quota_percent'].toDouble()
          : 0.0),
      address: json['address']?.toString() ?? '',
    );
  }
}

class WidgetListagem extends StatefulWidget {
  const WidgetListagem({super.key});

  @override
  State<WidgetListagem> createState() => _WidgetListagemState();
}

class _WidgetListagemState extends State<WidgetListagem> {
  List<DashboardContrato> contratos = [];
  String? erroCarregamento;

  @override
  void initState() {
    super.initState();
    carregarMock();
  }

  Future<void> carregarMock() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/contratos.json',
      );
      final List<dynamic> data = json.decode(response);
      contratos = data.map((e) => DashboardContrato.fromJson(e)).toList();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar contratos: $e');
      setState(() {
        erroCarregamento = 'Erro ao carregar os dados: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Lista de Contratos'),
        backgroundColor: kPrimaryBlue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: erroCarregamento != null
          ? Center(
              child: Text(
                erroCarregamento!,
                style: const TextStyle(color: kTextColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : contratos.isEmpty
          ? const Center(child: CircularProgressIndicator(color: kPrimaryBlue))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: contratos.length,
                itemBuilder: (context, index) {
                  final contrato = contratos[index];
                  return _ContratoCard(contrato: contrato);
                },
              ),
            ),
    );
  }
}

class _ContratoCard extends StatelessWidget {
  final DashboardContrato contrato;

  const _ContratoCard({required this.contrato});

  void _mostrarModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Teste'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double fontSizeBase = MediaQuery.of(context).textScaleFactor * 14;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            contrato.companyName,
            style: TextStyle(
              fontSize: fontSizeBase * 1.2,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            contrato.cnpj,
            style: TextStyle(fontSize: fontSizeBase * 0.9, color: kTextColor),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.description, size: 18, color: kPrimaryBlue),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Status: ${contrato.status[0].toUpperCase()}${contrato.status.substring(1)}',
                  style: TextStyle(
                    fontSize: fontSizeBase * 0.9,
                    color: contrato.status == 'processed'
                        ? kPrimaryGreen
                        : contrato.status == 'failed'
                        ? Colors.redAccent
                        : kPrimaryBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: kPrimaryBlue),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Data Upload: ${contrato.uploadedAt.substring(0, 10).split('-').reversed.join('/')}',
                  style: TextStyle(
                    fontSize: fontSizeBase * 0.9,
                    color: kTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.account_balance, size: 18, color: kPrimaryBlue),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Capital Social: R\$ ${contrato.capitalSocial.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    fontSize: fontSizeBase * 0.9,
                    color: kTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.label, size: 18, color: kPrimaryBlue),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Tipo: ${contrato.societyType}  |  Regime: ${contrato.corporateRegime}',
                  style: TextStyle(
                    fontSize: fontSizeBase * 0.9,
                    color: kTextColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.group, size: 18, color: kPrimaryBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Sócios: ${contrato.partners.isEmpty ? 'Nenhum sócio disponível' : contrato.partners.map((p) => p.name).join(', ')}',
                  style: TextStyle(
                    fontSize: fontSizeBase * 0.9,
                    color: kTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.visibility, size: 16),
                label: const Text('Visualizar'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: kPrimaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  textStyle: TextStyle(fontSize: fontSizeBase * 0.8),
                ),
              ),
              const SizedBox(width: 6),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Excluir'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  textStyle: TextStyle(fontSize: fontSizeBase * 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
