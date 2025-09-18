class ProcessingLog {
  final int? id;
  final String contractId;
  final String step;
  final String? message;
  final String createdAt;

  ProcessingLog({
    this.id,
    required this.contractId,
    required this.step,
    this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'step': step,
      'message': message,
      'created_at': createdAt,
    };
  }

  factory ProcessingLog.fromMap(Map<String, dynamic> map) {
    return ProcessingLog(
      id: map['id'],
      contractId: map['contract_id'],
      step: map['step'],
      message: map['message'],
      createdAt: map['created_at'],
    );
  }
}
