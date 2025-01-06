class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  // Factory constructor untuk parsing JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
    );
  }
}
