import 'history_transaction_response.dart';

class FamilyHistoryTransactionsResponse {
  final List<FamilyHistoryTransaction> data;
  final Meta meta;

  FamilyHistoryTransactionsResponse({required this.data, required this.meta});

  factory FamilyHistoryTransactionsResponse.fromJson(
      Map<String, dynamic> json) {
    return FamilyHistoryTransactionsResponse(
      data: (json['data'] as List)
          .map((item) => FamilyHistoryTransaction.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class FamilyHistoryTransaction {
  final int id;
  final int familyId;
  final int memberId;
  final double amount;
  final String transactionType;
  final String description;
  final String category;
  final String? imageUrl;
  final DateTime transactionAt;
  final Member member;

  FamilyHistoryTransaction({
    required this.id,
    required this.familyId,
    required this.memberId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.transactionAt,
    required this.member,
  });

  factory FamilyHistoryTransaction.fromJson(Map<String, dynamic> json) {
    return FamilyHistoryTransaction(
      id: json['id'],
      familyId: json['familyId'],
      memberId: json['memberId'],
      amount: json['amount'].toDouble(),
      transactionType: json['transactionType'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      transactionAt: DateTime.parse(json['transactionAt']),
      member: Member.fromJson(json['member']),
    );
  }
}

class Member {
  final UserData user;

  Member({required this.user});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final int id;
  final String username;
  final String email;
  final bool isVerified;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.isVerified,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      isVerified: json['isVerified'],
    );
  }
}
