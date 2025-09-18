class CapitalDetail {
  final int? id;
  final String contractId;
  final String type;
  final String? description;
  final double value;

  CapitalDetail({
    this.id,
    required this.contractId,
    required this.type,
    this.description,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'type': type,
      'description': description,
      'value': value,
    };
  }

  factory CapitalDetail.fromMap(Map<String, dynamic> map) {
    return CapitalDetail(
      id: map['id'],
      contractId: map['contract_id'],
      type: map['type'],
      description: map['description'],
      value: map['value'],
    );
  }
}
