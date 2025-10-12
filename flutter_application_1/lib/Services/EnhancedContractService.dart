import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Banco/DAO/ContractsDAO.dart';
import 'package:flutter_application_1/Banco/DAO/PartnerDAO.dart';
import 'package:flutter_application_1/Banco/DAO/ProcessingLogs.dart';
import 'package:flutter_application_1/Banco/DAO/ProcessingProtocolDAO.dart';
import 'package:flutter_application_1/Banco/entidades/Contract.dart';
import 'package:flutter_application_1/Banco/entidades/Partner.dart';
import 'package:flutter_application_1/Banco/entidades/ProcessingLog.dart';
import 'package:flutter_application_1/Banco/entidades/ProcessingProtocol.dart';
import 'package:uuid/uuid.dart';

class EnhancedContractService {
  final ContractDao _contractDao = ContractDao();
  final PartnerDao _partnerDao = PartnerDao();
  final ProcessingLogDao _logDao = ProcessingLogDao();
  final ProcessingProtocolDao _protocolDao = ProcessingProtocolDao();
  final Uuid _uuid = const Uuid();

  String generateProtocolCode() {
    final now = DateTime.now();
    final random = Random();
    final randomCode = String.fromCharCodes(
      List.generate(6, (index) => random.nextInt(26) + 65), // A-Z
    );
    return 'CTR-${now.year}-$randomCode';
  }

  String? validateFile(PlatformFile file) {
    const maxSizeInBytes = 10 * 1024 * 1024; // 10 MB
    if (file.extension?.toLowerCase() != 'pdf') {
      return 'Erro: O arquivo precisa ser um .pdf';
    }
    if (file.size > maxSizeInBytes) {
      return 'Erro: O arquivo é muito grande (máx. 10 MB)';
    }
    return null;
  }

  Future<Map<String, dynamic>> _mockAnalyzeApi(PlatformFile file) async {
    await Future.delayed(const Duration(seconds: 2));
    final String response = await rootBundle.loadString(
      'assets/contratos.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.first as Map<String, dynamic>;
  }

  Future<Contract?> findExistingContractByCnpj(String cnpj) async {
    final contracts = await _contractDao.readAll();
    try {
      return contracts.firstWhere(
        (c) =>
            c.cnpj?.replaceAll(RegExp(r'\D'), '') ==
            cnpj.replaceAll(RegExp(r'\D'), ''),
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> uploadAndProcessContractWithProtocol({
    required PlatformFile file,
    String? customName,
    String? notes,
    required Function(String step, int progress, String? protocolCode)
    onProgress,
  }) async {
    final contractId = _uuid.v4();
    final protocolCode = generateProtocolCode();
    final now = DateTime.now().toIso8601String();

    try {
      final initialContract = Contract(
        id: contractId,
        filename: customName ?? file.name,
        uploadedAt: now,
        status: 'pending',
        notes: notes,
      );
      await _contractDao.create(initialContract);

      final protocol = ProcessingProtocol(
        protocolCode: protocolCode,
        contractId: contractId,
        status: 'pending',
        currentStep: 'upload',
        progress: 0,
        fileName: file.name,
        createdAt: now,
      );
      await _protocolDao.create(protocol);

      onProgress('upload', 10, protocolCode);
      await Future.delayed(const Duration(seconds: 2));

      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'upload_started',
          createdAt: now,
        ),
      );

      onProgress('upload', 20, protocolCode);
      await _protocolDao.update(
        protocol.copyWith(currentStep: 'validation', progress: 20),
      );

      onProgress('validation', 25, protocolCode);
      await Future.delayed(const Duration(seconds: 2));

      final validationError = validateFile(file);
      if (validationError != null) {
        throw Exception(validationError);
      }

      onProgress('validation', 40, protocolCode);
      await _protocolDao.update(
        protocol.copyWith(currentStep: 'analysis', progress: 40),
      );

      onProgress('analysis', 45, protocolCode);
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'api_call_started',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));
      final apiResponse = await _mockAnalyzeApi(file);

      onProgress('analysis', 60, protocolCode);
      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'api_call_success',
          message: jsonEncode(apiResponse),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      await _protocolDao.update(
        protocol.copyWith(currentStep: 'extraction', progress: 60),
      );

      onProgress('extraction', 65, protocolCode);
      await Future.delayed(const Duration(seconds: 2));

      final existingContract = await findExistingContractByCnpj(
        apiResponse['cnpj'],
      );
      if (existingContract != null) {
        apiResponse['duplicate_warning'] = {
          'exists': true,
          'existing_contract_id': existingContract.id,
          'message': 'Já existe um contrato com este CNPJ',
        };
      }

      onProgress('extraction', 80, protocolCode);
      await _protocolDao.update(
        protocol.copyWith(currentStep: 'saving', progress: 80),
      );

      onProgress('saving', 85, protocolCode);
      await Future.delayed(const Duration(seconds: 2));

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

      final partners =
          (apiResponse['partners'] as List)
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

      onProgress('saving', 95, protocolCode);

      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'save_success',
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      onProgress('saving', 100, protocolCode);
      await _protocolDao.update(
        protocol.copyWith(
          status: 'completed',
          progress: 100,
          completedAt: DateTime.now().toIso8601String(),
        ),
      );

      apiResponse['protocol_code'] = protocolCode;
      apiResponse['contract_id'] = contractId;

      return apiResponse;
    } catch (e) {
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

      await _protocolDao.update(
        ProcessingProtocol(
          protocolCode: protocolCode,
          contractId: contractId,
          status: 'failed',
          currentStep: 'error',
          progress: 0,
          fileName: file.name,
          createdAt: now,
          errorMessage: e.toString(),
        ),
      );

      await _logDao.create(
        ProcessingLog(
          contractId: contractId,
          step: 'error',
          message: e.toString(),
          createdAt: DateTime.now().toIso8601String(),
        ),
      );

      throw Exception("Falha ao processar o contrato: ${e.toString()}");
    }
  }

  Future<ProcessingProtocol?> getProtocolStatus(String protocolCode) async {
    return await _protocolDao.read(protocolCode);
  }

  Future<List<ProcessingProtocol>> getAllProtocols() async {
    return await _protocolDao.readAll();
  }
}
