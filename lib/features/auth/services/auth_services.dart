import 'dart:convert';
import 'package:http/http.dart' as http;
// import '../../../core/consts/base_url.dart';
import '../../../core/consts/base_url.dart';
import '../data/models/login_response.dart';
import '../data/models/message_response.dart';
import '../data/models/verification_response.dart';

class AuthService {
  Future<LoginResponse?> loginUser({
    required String identifier,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final body = {
      "identifier": identifier,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<MessageResponse?> registrationUser({
    required String username,
    required String email,
    required String password,
    required String confirmNewPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final body = {
      "username": username,
      "email": email,
      "password": password,
      "confirmPassword": confirmNewPassword,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return MessageResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<MessageResponse?> changePassword({
    required String identifier,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/password');
    final body = {
      "identifier": identifier,
      "oldPassword": oldPassword,
      "newPassword": newPassword,
      "confirmNewPassword": confirmNewPassword,
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return MessageResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<VerificationResponse> verifyEmail({
    required String email,
    required String verificationCode,
  }) async {
    final url = Uri.parse("$baseUrl/auth/verify");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'verificationCode': verificationCode,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return VerificationResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }
}
