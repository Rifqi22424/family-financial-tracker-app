import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/consts/base_url.dart';
import '../../auth/data/models/message_response.dart';
import '../data/models/family_member.dart';

class FamilyService {
  Future<MessageResponse> joinFamily({
    required String familyCode,
    required String role,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/family/join");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'familyCode': familyCode,
          'role': role,
        }),
      );

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

  // Create Family
  Future<MessageResponse> createFamily({
    required String name,
    required String role,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/family");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'role': role,
        }),
      );

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

  Future<List<FamilyMember>> fetchFamilyMembers({required String token}) async {
    final url = Uri.parse('$baseUrl/family/members');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((member) => FamilyMember.fromJson(member))
          .toList();
    } else {
      throw Exception('Failed to fetch family members');
    }
  }
}
