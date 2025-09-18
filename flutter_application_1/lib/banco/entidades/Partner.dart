class Partner {
  final int? id;
  final String contractId;
  final String name;
  final String? cpfCnpj;
  final String? qualification;
  final String? role;
  final double? quotaPercent;
  final double? capitalSubscribed;
  final String? address;

  Partner({
    this.id,
    required this.contractId,
    required this.name,
    this.cpfCnpj,
    this.qualification,
    this.role,
    this.quotaPercent,
    this.capitalSubscribed,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contract_id': contractId,
      'name': name,
      'cpf_cnpj': cpfCnpj,
      'qualification': qualification,
      'role': role,
      'quota_percent': quotaPercent,
      'capital_subscribed': capitalSubscribed,
      'address': address,
    };
  }

  factory Partner.fromMap(Map<String, dynamic> map) {
    return Partner(
      id: map['id'],
      contractId: map['contract_id'],
      name: map['name'],
      cpfCnpj: map['cpf_cnpj'],
      qualification: map['qualification'],
      role: map['role'],
      quotaPercent: map['quota_percent'],
      capitalSubscribed: map['capital_subscribed'],
      address: map['address'],
    );
  }
}
