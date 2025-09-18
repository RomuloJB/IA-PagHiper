class Contract {
  final String id;
  final String? userId;
  final String filename;
  final String? hash;
  final String uploadedAt;
  final String? processedAt;
  final String status;
  final String? companyName;
  final String? cnpj;
  final String? foundationDate;
  final double? capitalSocial;
  final String? address;
  final int? contractTypeId;
  final int? corporateRegimeId;
  final int? societyTypeId;
  final double? confidence;
  final String? rawJson;
  final String? notes;

  Contract({
    required this.id,
    this.userId,
    required this.filename,
    this.hash,
    required this.uploadedAt,
    this.processedAt,
    required this.status,
    this.companyName,
    this.cnpj,
    this.foundationDate,
    this.capitalSocial,
    this.address,
    this.contractTypeId,
    this.corporateRegimeId,
    this.societyTypeId,
    this.confidence,
    this.rawJson,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'filename': filename,
      'hash': hash,
      'uploaded_at': uploadedAt,
      'processed_at': processedAt,
      'status': status,
      'company_name': companyName,
      'cnpj': cnpj,
      'foundation_date': foundationDate,
      'capital_social': capitalSocial,
      'address': address,
      'contract_type_id': contractTypeId,
      'corporate_regime_id': corporateRegimeId,
      'society_type_id': societyTypeId,
      'confidence': confidence,
      'raw_json': rawJson,
      'notes': notes,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id'],
      userId: map['user_id'],
      filename: map['filename'],
      hash: map['hash'],
      uploadedAt: map['uploaded_at'],
      processedAt: map['processed_at'],
      status: map['status'],
      companyName: map['company_name'],
      cnpj: map['cnpj'],
      foundationDate: map['foundation_date'],
      capitalSocial: map['capital_social'],
      address: map['address'],
      contractTypeId: map['contract_type_id'],
      corporateRegimeId: map['corporate_regime_id'],
      societyTypeId: map['society_type_id'],
      confidence: map['confidence'],
      rawJson: map['raw_json'],
      notes: map['notes'],
    );
  }
}
