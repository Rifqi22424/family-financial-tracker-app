class VerificationResponse {
  final String message;
  final String token;

  VerificationResponse({required this.message, required this.token});

  // Factory constructor untuk parsing JSON
  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      message: json['message'],
      token: json['token'],
    );
  }
}
