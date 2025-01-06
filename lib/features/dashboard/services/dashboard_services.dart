import 'dart:convert';
import 'package:financial_family_tracker/features/dashboard/data/models/recent_transaction_response.dart';
import 'package:http/http.dart' as http;
import '../../../core/consts/base_url.dart';
import '../data/models/history_transaction_response.dart';

class DashboardServices {
  Future<double> getBalance({required token}) async {
    final url = Uri.parse("$baseUrl/transaction");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['balance']?.toDouble() ?? 0.0;
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<RecentTransactionsResponse> getRecentTransactions({
    int page = 1,
    int limit = 10,
    required token,
  }) async {
    final url =
        Uri.parse("$baseUrl/transaction/recent?page=$page&limit=$limit");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return RecentTransactionsResponse.fromJson(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<double> getTotalTransaction({
    required String transactionType, // "INCOME" or "EXPENSE"
    required String timePeriod, // "day", "week", "month", "year", or "all"
    required token,
  }) async {
    final url = Uri.parse(
        "$baseUrl/transaction/total?transactionType=$transactionType&timePeriod=$timePeriod");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['total']?.toDouble() ?? 0.0;
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Something went wrong";
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<void> addTransaction({
    required String token,
    required double amount,
    required String transactionType, // "INCOME" or "EXPENSE"
    required String category,
    required DateTime transactionAt,
    String description = "",
  }) async {
    final url = Uri.parse("$baseUrl/transaction");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'transactionType': transactionType,
          'category': category,
          'amount': amount,
          'description': description,
          'transactionAt': transactionAt.toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Gagal menambahkan transaksi.";
      }
    } catch (e) {
      print("Error in addTransaction: ${e.toString()}");
      throw e;
    }
  }

  Future<void> transfer({
    required String token,
    required double amount,
    required int recipientId,
    String description = "",
  }) async {
    final url = Uri.parse("$baseUrl/transaction/transfer");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'description': description,
          'recipientId': recipientId,
        }),
      );

      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw errorData["error"]["message"] ?? "Gagal menambahkan transfer.";
      }
    } catch (e) {
      print("Error in addTransfer: ${e.toString()}");
      throw e;
    }
  }

  Future<HistoryTransactionsResponse> getHistoryTransactions({
    required String token,
    int page = 1,
    int limit = 10,
    required String transactionType,
    String timePeriod = "all",
  }) async {
    final url = Uri.parse(
        "$baseUrl/transaction/history?transactionType=$transactionType&timePeriod=$timePeriod&page=$page&limit=$limit");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return HistoryTransactionsResponse.fromJson(responseData);
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
