class ContractChange {
  final int? id;
  final String contractId;
  final String changeDate;
  final String? changeType;
  final String description;

  ContractChange({
    this.id,
    required this.contractId,
    required this.changeDate,
    this.changeType,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'change_date': changeDate,
      'change_type': changeType,
      'description': description,
    };
  }

  factory ContractChange.fromMap(Map<String, dynamic> map) {
    return ContractChange(
      id: map['id'],
      contractId: map['contract_id'],
      changeDate: map['change_date'],
      changeType: map['change_type'],
      description: map['description'],
    );
  }
}
