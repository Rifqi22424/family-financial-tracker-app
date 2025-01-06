class RecentTransactionsResponse {
  final List<TransactionData> data;
  final MetaData meta;

  RecentTransactionsResponse({
    required this.data,
    required this.meta,
  });

  factory RecentTransactionsResponse.fromJson(Map<String, dynamic> json) {
    return RecentTransactionsResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => TransactionData.fromJson(item))
          .toList(),
      meta: MetaData.fromJson(json['meta']),
    );
  }

  @override
  String toString() {
    return 'RecentTransactionsResponse(\n'
        '  data: ${data.map((d) => d.toString()).toList()},\n'
        '  meta: $meta\n'
        ')';
  }
}

class TransactionData {
  final int id;
  final int familyId;
  final int memberId;
  final double amount;
  final String transactionType;
  final String description;
  final String category;
  final String? imageUrl;
  final DateTime transactionAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionData({
    required this.id,
    required this.familyId,
    required this.memberId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.transactionAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'],
      familyId: json['familyId'],
      memberId: json['memberId'],
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transactionType'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      transactionAt: DateTime.parse(json['transactionAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'TransactionData(\n'
        '  id: $id, familyId: $familyId, memberId: $memberId, amount: $amount,\n'
        '  transactionType: $transactionType, description: $description, category: $category,\n'
        '  imageUrl: $imageUrl, transactionAt: $transactionAt,\n'
        '  createdAt: $createdAt, updatedAt: $updatedAt\n'
        ')';
  }
}

class MetaData {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  MetaData({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  @override
  String toString() {
    return 'MetaData(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
  }
}
