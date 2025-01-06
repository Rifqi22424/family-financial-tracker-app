class MessageResponse {
  final String message;

  MessageResponse({required this.message});

  // Factory constructor untuk parsing JSON
  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      message: json['message'],
    );
  }
}
