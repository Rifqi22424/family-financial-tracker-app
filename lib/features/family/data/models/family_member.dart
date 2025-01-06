class FamilyMember {
  final int id;
  final int userId;
  final int familyId;
  final String role;
  final bool isFamilyHead;
  final bool canAddIncome;
  final bool canViewFamilyReport;
  final int balance;
  final String createdAt;
  final String updatedAt;
  final User user;

  FamilyMember({
    required this.id,
    required this.userId,
    required this.familyId,
    required this.role,
    required this.isFamilyHead,
    required this.canAddIncome,
    required this.canViewFamilyReport,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      userId: json['userId'],
      familyId: json['familyId'],
      role: json['role'],
      isFamilyHead: json['isFamilyHead'],
      canAddIncome: json['canAddIncome'],
      canViewFamilyReport: json['canViewFamilyReport'],
      balance: json['balance'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
