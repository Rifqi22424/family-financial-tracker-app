class LoginResponse {
  final String token;
  final UserLoginData user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  // Factory constructor untuk parsing JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: UserLoginData.fromJson(json['user']),
    );
  }
}

class UserLoginData {
  final int id;
  final String username;
  final String email;

  UserLoginData({
    required this.id,
    required this.username,
    required this.email,
  });

  // Factory constructor untuk parsing JSON
  factory UserLoginData.fromJson(Map<String, dynamic> json) {
    return UserLoginData(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
