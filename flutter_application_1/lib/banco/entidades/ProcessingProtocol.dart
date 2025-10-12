class ProcessingProtocol {
  final String protocolCode;
  final String contractId;
  final String
  status; // 'pending', 'processing', 'validating', 'completed', 'failed'
  final String?
  currentStep; // 'upload', 'validation', 'analysis', 'extraction', 'saving'
  final int? progress; // 0-100
  final String? fileName;
  final String createdAt;
  final String? completedAt;
  final String? errorMessage;

  ProcessingProtocol({
    required this.protocolCode,
    required this.contractId,
    required this.status,
    this.currentStep,
    this.progress,
    this.fileName,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'protocol_code': protocolCode,
      'contract_id': contractId,
      'status': status,
      'current_step': currentStep,
      'progress': progress,
      'file_name': fileName,
      'created_at': createdAt,
      'completed_at': completedAt,
      'error_message': errorMessage,
    };
  }

  factory ProcessingProtocol.fromMap(Map<String, dynamic> map) {
    return ProcessingProtocol(
      protocolCode: map['protocol_code'],
      contractId: map['contract_id'],
      status: map['status'],
      currentStep: map['current_step'],
      progress: map['progress'],
      fileName: map['file_name'],
      createdAt: map['created_at'],
      completedAt: map['completed_at'],
      errorMessage: map['error_message'],
    );
  }

  ProcessingProtocol copyWith({
    String? status,
    String? currentStep,
    int? progress,
    String? completedAt,
    String? errorMessage,
  }) {
    return ProcessingProtocol(
      protocolCode: protocolCode,
      contractId: contractId,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      progress: progress ?? this.progress,
      fileName: fileName,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
