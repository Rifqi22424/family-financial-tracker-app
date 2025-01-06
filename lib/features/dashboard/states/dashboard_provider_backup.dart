// import 'package:flutter/material.dart';
// import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
// import '../data/models/recent_transaction_response.dart';
// import '../services/dashboard_services.dart';

// enum DashboardState { initial, loading, success, error }

// class DashboardProvider with ChangeNotifier {
//   final DashboardServices _dashboardService = DashboardServices();
//   DashboardState _state = DashboardState.initial;

//   String? _errorMessage;
//   double? _balance;
//   List<TransactionData> _recentTransactions = [];
//   double? _totalExpense;
//   double? _totalIncome;

//   DashboardState get state => _state;
//   String? get errorMessage => _errorMessage;
//   double? get balance => _balance;
//   List<TransactionData> get recentTransactions => _recentTransactions;
//   double? get totalExpense => _totalExpense;
//   double? get totalIncome => _totalIncome;

//   Future<void> fetchDashboardData() async {
//     _state = DashboardState.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       await Future.wait([
//         getBalance(),
//         getRecentTransactions(),
//         getTotalExpense(),
//         getTotalIncome(),
//       ]);

//       _state = DashboardState.success;
//     } catch (e) {
//       _errorMessage = "Error saat mengambil data dashboard: ${e.toString()}";
//       _state = DashboardState.error;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> getBalance() async {
//     _state = DashboardState.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final String? token = await SharedPreferencesHelper.getAuthToken();
//       if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

//       _balance = await _dashboardService.getBalance(token: token);
//       _state = DashboardState.success;
//     } catch (e) {
//       _errorMessage = e.toString();
//       print("masuk balance $_errorMessage");
//       _state = DashboardState.error;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> getRecentTransactions({int page = 1, int limit = 10}) async {
//     _state = DashboardState.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final String? token = await SharedPreferencesHelper.getAuthToken();
//       if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

//       RecentTransactionsResponse response =
//           await _dashboardService.getRecentTransactions(
//         token: token,
//         page: page,
//         limit: limit,
//       );

//       _recentTransactions = response.data;
//       _state = DashboardState.success;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _state = DashboardState.error;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> getTotalExpense({
//     String transactionType = "EXPENSE",
//     String timePeriod = "all",
//   }) async {
//     _state = DashboardState.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final String? token = await SharedPreferencesHelper.getAuthToken();
//       if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

//       _totalExpense = await _dashboardService.getTotalTransaction(
//         token: token,
//         transactionType: transactionType,
//         timePeriod: timePeriod,
//       );
//       _state = DashboardState.success;
//     } catch (e) {
//       _errorMessage = e.toString();
//       print("error fetch expense income $_errorMessage");
//       _state = DashboardState.error;
//     } finally {
//       notifyListeners();
//     }
//   }

//   Future<void> getTotalIncome({
//     String transactionType = "INCOME",
//     String timePeriod = "all",
//   }) async {
//     _state = DashboardState.loading;
//     _errorMessage = null;
//     notifyListeners();

//     try {
//       final String? token = await SharedPreferencesHelper.getAuthToken();
//       if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

//       _totalIncome = await _dashboardService.getTotalTransaction(
//         token: token,
//         transactionType: transactionType,
//         timePeriod: timePeriod,
//       );
//       _state = DashboardState.success;
//     } catch (e) {
//       _errorMessage = e.toString();
//       _state = DashboardState.error;
//     } finally {
//       notifyListeners();
//     }
//   }

//   void resetState() {
//     _state = DashboardState.initial;
//     _errorMessage = null;
//     _balance = null;
//     _recentTransactions.clear();
//     _totalExpense = null;
//     notifyListeners();
//   }
// }
