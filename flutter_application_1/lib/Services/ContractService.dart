import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_1/banco/DAO/ContractsDAO.dart';
import 'package:flutter_application_1/banco/DAO/PartnerDAO.dart';
import 'package:flutter_application_1/banco/DAO/ProcessingLogs.dart';
import 'package:flutter_application_1/banco/entidades/Contract.dart';
import 'package:flutter_application_1/banco/entidades/Partner.dart';
import 'package:flutter_application_1/banco/entidades/ProcessingLog.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ContractService {
  final ContractDao _contractDao = ContractDao();
  final PartnerDao _partnerDao = PartnerDao();
  final ProcessingLogDao _logDao = ProcessingLogDao();
  final Uuid _uuid = const Uuid();

  // 1. Validação do arquivo
  String? validateFile(PlatformFile file) {
    const maxSizeInBytes = 10 * 1024 * 1024; // 10 MB

    if (file.extension?.toLowerCase() != 'pdf') {
      return 'Erro: O arquivo precisa ser um .pdf';
    }

    if (file.size > maxSizeInBytes) {
      return 'Erro: O arquivo é muito grande (máx. 10 MB)';
    }

    return null; // Sem erros
  }

  // 2. Simulação da chamada à API
  Future<Map<String, dynamic>> _mockAnalyzeApi(PlatformFile file) async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(seconds: 3));

    // Simula uma falha aleatória na API (20% de chance de falhar)
    if (Random().nextDouble() < 0.2) {
      throw Exception("Falha de conexão com a API de análise.");
    }

    // Retorna um JSON mockado com dados extraídos do contrato
    return {
      "company_name": "Empresa Fictícia LTDA",
      "cnpj": "12.345.678/0001-99",
      "foundation_date": "2023-05-15",
      "capital_social": 100000.50,
      "address": "Rua dos Contratos, 123",
      "city": "São Paulo",
      "state": "SP",
      "confidence": 0.95,
      "partners": [
        {
          "name": "João da Silva",
          "cpf_cnpj": "111.222.333-44",
          "role": "Administrador",
        },
        {
          "name": "Maria Oliveira",
          "cpf_cnpj": "444.555.666-77",
          "role": "Sócio",
        },
      ],
    };
  }

  // 3. Processo principal: orquestra tudo
  Future<void> uploadAndProcessContract({
    required PlatformFile file,
    String? customName,
    String? notes,
  }) async {
    final contractId = _uuid.v4();
    final now = DateTime.now().toIso8601String();

    try {
      // Passo 1: Salva o contrato com status 'pending'
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'upload_started',
          createdAt: now,
        ),
      );

      final initialContract = Contract(
        id: contractId,
        filename: customName ?? file.name,
        uploadedAt: now,
        status: 'pending',
        notes: notes,
      );
      await _contractDao.create(initialContract);

      // Passo 2: Envia para a API (mock)
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'api_call_started',
          createdAt: now,
        ),
      );
      final apiResponse = await _mockAnalyzeApi(file);
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'api_call_success',
          message: jsonEncode(apiResponse),
          createdAt: now,
        ),
      );

      // Passo 3: Atualiza o contrato com os dados da API
      final processedContract = Contract(
        id: contractId,
        filename: customName ?? file.name,
        uploadedAt: initialContract.uploadedAt,
        processedAt: DateTime.now().toIso8601String(),
        status: 'processed',
        notes: notes,
        companyName: apiResponse['company_name'],
        cnpj: apiResponse['cnpj'],
        foundationDate: apiResponse['foundation_date'],
        capitalSocial: (apiResponse['capital_social'] as num).toDouble(),
        address: apiResponse['address'],

        confidence: (apiResponse['confidence'] as num).toDouble(),
        rawJson: jsonEncode(apiResponse),
      );
      await _contractDao.update(processedContract);

      // Passo 4: Salva os sócios retornados pela API
      final partners = (apiResponse['partners'] as List)
          .map(
            (p) => Partner(
              contractId: contractId,
              name: p['name'],
              cpfCnpj: p['cpf_cnpj'],
              role: p['role'],
            ),
          )
          .toList();

      for (var partner in partners) {
        await _partnerDao.create(partner);
      }

      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'save_success',
          createdAt: now,
        ),
      );
    } catch (e) {
      // Em caso de erro, atualiza o status para 'failed'
      final failedContract = await _contractDao.read(contractId);
      if (failedContract != null) {
        await _contractDao.update(
          Contract(
            id: failedContract.id,
            filename: failedContract.filename,
            uploadedAt: failedContract.uploadedAt,
            status: 'failed',
            notes: failedContract.notes,
          ),
        );
      }
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'error',
          message: e.toString(),
          createdAt: now,
        ),
      );
      // Re-lança o erro para ser pego pela UI
      throw Exception("Falha ao processar o contrato: ${e.toString()}");
    }
  }
}
