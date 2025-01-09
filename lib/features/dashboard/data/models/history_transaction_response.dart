class HistoryTransactionsResponse {
  final List<HistoryTransaction> data;
  final Meta meta;

  HistoryTransactionsResponse({required this.data, required this.meta});

  factory HistoryTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return HistoryTransactionsResponse(
      data: (json['data'] as List)
          .map((item) => HistoryTransaction.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class HistoryTransaction {
  final int id;
  final int familyId;
  final int memberId;
  final double amount;
  final String transactionType;
  final String description;
  final String category;
  final String? imageUrl;
  final DateTime transactionAt;

  HistoryTransaction({
    required this.id,
    required this.familyId,
    required this.memberId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.transactionAt,
  });

  factory HistoryTransaction.fromJson(Map<String, dynamic> json) {
    return HistoryTransaction(
      id: json['id'],
      familyId: json['familyId'],
      memberId: json['memberId'],
      amount: json['amount'].toDouble(),
      transactionType: json['transactionType'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      transactionAt: DateTime.parse(json['transactionAt']),
    );
  }

  HistoryTransaction copyWith({
    int? id,
    int? familyId,
    int? memberId,
    double? amount,
    String? transactionType,
    String? description,
    String? category,
    String? imageUrl,
    DateTime? transactionAt,
  }) {
    return HistoryTransaction(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      transactionAt: transactionAt ?? this.transactionAt,
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  @override
  String toString() {
    return 'Meta(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
  }
}
