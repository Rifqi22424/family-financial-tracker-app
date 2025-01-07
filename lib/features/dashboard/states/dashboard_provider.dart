import 'package:flutter/material.dart';
import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
import '../../family/data/models/family_member.dart';
import '../../family/services/family_services.dart';
import '../data/models/family_history_trasnsaction_response.dart';
import '../data/models/history_transaction_response.dart';
import '../data/models/recent_transaction_response.dart';
import '../services/dashboard_services.dart';

enum DashboardState { initial, loading, success, error }

class DashboardProvider with ChangeNotifier {
  final DashboardServices _dashboardService = DashboardServices();

  final FamilyService _familyService = FamilyService();

  // Separate states for each operation
  DashboardState _balanceState = DashboardState.initial;
  DashboardState _familyMembersState = DashboardState.initial;
  DashboardState _familyHistoryIncomeState = DashboardState.initial;
  DashboardState _familyHistoryExpenseState = DashboardState.initial;
  DashboardState _historyIncomeState = DashboardState.initial;
  DashboardState _historyExpenseState = DashboardState.initial;
  DashboardState _recentTransactionsState = DashboardState.initial;
  DashboardState _totalExpenseState = DashboardState.initial;
  DashboardState _totalIncomeState = DashboardState.initial;
  DashboardState _addIncomeState = DashboardState.initial;
  DashboardState _addExpenseState = DashboardState.initial;
  DashboardState _transferState = DashboardState.initial;

  // Error messages for each operation
  String? _familyHistoryIncomeError;
  String? _familyHistoryExpenseError;
  String? _historyIncomeError;
  String? _historyExpenseError;
  String? _transferError;
  String? _balanceError;
  String? _familyMembersError;
  String? _recentTransactionsError;
  String? _totalExpenseError;
  String? _totalIncomeError;
  String? _addIncomeError;
  String? _addExpenseError;

  // Data
  double? _balance;
  Meta? _familyHistoryExpenseMeta;
  Meta? _familyHistoryIncomeMeta;
  List<FamilyHistoryTransaction> _familyHistoryExpense = [];
  List<FamilyHistoryTransaction> _familyHistoryIncome = [];
  Meta? _historyExpenseMeta;
  Meta? _historyIncomeMeta;
  List<HistoryTransaction> _historyExpense = [];
  List<HistoryTransaction> _historyIncome = [];
  List<TransactionData> _recentTransactions = [];
  List<FamilyMember> _familyMembers = [];
  double? _totalExpense;
  double? _totalIncome;

  // Getters for states
  DashboardState get familyHistoryIncomeState => _familyHistoryIncomeState;
  DashboardState get familyHistoryExpenseState => _familyHistoryExpenseState;
  DashboardState get historyIncomeState => _historyIncomeState;
  DashboardState get historyExpenseState => _historyExpenseState;
  DashboardState get balanceState => _balanceState;
  DashboardState get familyMembersState => _familyMembersState;
  DashboardState get recentTransactionsState => _recentTransactionsState;
  DashboardState get totalExpenseState => _totalExpenseState;
  DashboardState get totalIncomeState => _totalIncomeState;
  DashboardState get transferState => _transferState;
  DashboardState get addIncomeState => _addIncomeState;
  DashboardState get addExpenseState => _addExpenseState;

  // Getters for error messages
  String? get familyHistoryExpenseError => _familyHistoryExpenseError;
  String? get familyHistoryIncomeError => _familyHistoryIncomeError;
  String? get historyExpenseError => _historyExpenseError;
  String? get historyIncomeError => _historyIncomeError;
  String? get transferError => _transferError;
  String? get balanceError => _balanceError;
  String? get familyMembersError => _familyMembersError;
  String? get recentTransactionsError => _recentTransactionsError;
  String? get totalExpenseError => _totalExpenseError;
  String? get totalIncomeError => _totalIncomeError;
  String? get addIncomeError => _addIncomeError;
  String? get addExpenseError => _addExpenseError;

  // Getters for data
  double? get balance => _balance;
  List<FamilyMember> get familyMembers => _familyMembers;
  List<TransactionData> get recentTransactions => _recentTransactions;
  double? get totalExpense => _totalExpense;
  double? get totalIncome => _totalIncome;
  List<HistoryTransaction> get historyExpense => _historyExpense;
  List<HistoryTransaction> get historyIncome => _historyIncome;
  Meta? get historyExpenseMeta => _historyExpenseMeta;
  Meta? get historyIncomeMeta => _historyIncomeMeta;

  List<FamilyHistoryTransaction> get familyHistoryExpense =>
      _familyHistoryExpense;
  List<FamilyHistoryTransaction> get familyHistoryIncome =>
      _familyHistoryIncome;
  Meta? get familyHistoryExpenseMeta => _familyHistoryExpenseMeta;
  Meta? get familyHistoryIncomeMeta => _familyHistoryIncomeMeta;

  Future<void> fetchDashboardData() async {
    try {
      await Future.wait([
        getBalance(),
        getRecentTransactions(),
        getTotalExpense(),
        getTotalIncome(),
        getFamilyMembers(),
        getHistoryExpense(),
        getHistoryIncome(),
        getFamilyHistoryExpense(),
        getFamilyHistoryIncome(),
      ]);
    } catch (e) {
      print("Error fetching dashboard data: ${e.toString()}");
    }
  }

  Future<void> getBalance() async {
    _balanceState = DashboardState.loading;
    _balanceError = null;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      _balance = await _dashboardService.getBalance(token: token);
      _balanceState = DashboardState.success;
    } catch (e) {
      _balanceError = e.toString();
      _balanceState = DashboardState.error;
      print("Balance error: $_balanceError");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getHistoryExpense({
    int page = 1,
    int limit = 10,
    String transactionType = "EXPENSE",
    String timePeriod = "all",
  }) async {
    if (_historyExpenseState == DashboardState.loading) return;

    if (page == 1) {
      _historyExpenseState = DashboardState.loading;
      _historyExpenseError = null;
      _historyExpense = [];
    }
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      HistoryTransactionsResponse response =
          await _dashboardService.getHistoryTransactions(
        token: token,
        page: page,
        limit: limit,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );

      if (page == 1) {
        _historyExpense = response.data;
      } else {
        _historyExpense.addAll(response.data);
      }
      _historyExpenseMeta = response.meta;
      _historyExpenseState = DashboardState.success;
    } catch (e) {
      _historyExpenseError = e.toString();
      _historyExpenseState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getHistoryIncome({
    int page = 1,
    int limit = 10,
    String transactionType = "INCOME",
    String timePeriod = "all",
  }) async {
    if (_historyIncomeState == DashboardState.loading) return;

    if (page == 1) {
      _historyIncomeState = DashboardState.loading;
      _historyIncomeError = null;
      _historyIncome = [];
    }
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      HistoryTransactionsResponse response =
          await _dashboardService.getHistoryTransactions(
        token: token,
        page: page,
        limit: limit,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );

      if (page == 1) {
        _historyIncome = response.data;
      } else {
        _historyIncome.addAll(response.data);
      }
      _historyIncomeMeta = response.meta;
      _historyIncomeState = DashboardState.success;
    } catch (e) {
      _historyIncomeError = e.toString();
      _historyIncomeState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getFamilyHistoryIncome({
    int page = 1,
    int limit = 10,
    String transactionType = "INCOME",
    String timePeriod = "all",
  }) async {
    if (_familyHistoryIncomeState == DashboardState.loading) return;

    if (page == 1) {
      _familyHistoryIncomeState = DashboardState.loading;
      _familyHistoryIncomeError = null;
      _familyHistoryIncome = [];
    }
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      FamilyHistoryTransactionsResponse response =
          await _dashboardService.getFamilyHistoryTransactions(
        token: token,
        page: page,
        limit: limit,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );

      if (page == 1) {
        _familyHistoryIncome = response.data;
      } else {
        _familyHistoryIncome.addAll(response.data);
      }
      _familyHistoryIncomeMeta = response.meta;
      _familyHistoryIncomeState = DashboardState.success;
    } catch (e) {
      _familyHistoryIncomeError = e.toString();
      _familyHistoryIncomeState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getFamilyHistoryExpense({
    int page = 1,
    int limit = 10,
    String transactionType = "EXPENSE",
    String timePeriod = "all",
  }) async {
    if (_familyHistoryExpenseState == DashboardState.loading) return;

    if (page == 1) {
      _familyHistoryExpenseState = DashboardState.loading;
      _familyHistoryExpenseError = null;
      _familyHistoryExpense = [];
    }
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      FamilyHistoryTransactionsResponse response =
          await _dashboardService.getFamilyHistoryTransactions(
        token: token,
        page: page,
        limit: limit,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );

      if (page == 1) {
        _familyHistoryExpense = response.data;
      } else {
        _familyHistoryExpense.addAll(response.data);
      }
      _familyHistoryExpenseMeta = response.meta;
      print("meta expense ${response.meta.toString()}");
      _familyHistoryExpenseState = DashboardState.success;
    } catch (e) {
      _familyHistoryExpenseError = e.toString();
      _familyHistoryExpenseState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getRecentTransactions({int page = 1, int limit = 10}) async {
    _recentTransactionsState = DashboardState.loading;
    _recentTransactionsError = null;
    _recentTransactions = [];
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      RecentTransactionsResponse response =
          await _dashboardService.getRecentTransactions(
        token: token,
        page: page,
        limit: limit,
      );

      _recentTransactions = response.data;
      _recentTransactionsState = DashboardState.success;
    } catch (e) {
      _recentTransactionsError = e.toString();
      _recentTransactionsState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getFamilyMembers() async {
    _familyMembersState = DashboardState.loading;
    _familyMembersError = null;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      _familyMembers = await _familyService.fetchFamilyMembers(token: token);
      _familyMembersState = DashboardState.success;
    } catch (e) {
      _familyMembersError = e.toString();
      _familyMembersState = DashboardState.error;
      print("Total expense error: $_familyMembersError");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getTotalExpense({
    String transactionType = "EXPENSE",
    String timePeriod = "all",
  }) async {
    _totalExpenseState = DashboardState.loading;
    _totalExpenseError = null;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      _totalExpense = await _dashboardService.getTotalTransaction(
        token: token,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );
      _totalExpenseState = DashboardState.success;
    } catch (e) {
      _totalExpenseError = e.toString();
      _totalExpenseState = DashboardState.error;
      print("Total expense error: $_totalExpenseError");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getTotalIncome({
    String transactionType = "INCOME",
    String timePeriod = "all",
  }) async {
    _totalIncomeState = DashboardState.loading;
    _totalIncomeError = null;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      _totalIncome = await _dashboardService.getTotalTransaction(
        token: token,
        transactionType: transactionType,
        timePeriod: timePeriod,
      );
      _totalIncomeState = DashboardState.success;
    } catch (e) {
      _totalIncomeError = e.toString();
      _totalIncomeState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addIncome({
    required String category,
    required double amount,
    required DateTime transactionAt,
    String description = "",
  }) async {
    _addIncomeState = DashboardState.loading;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      await _dashboardService.addTransaction(
        token: token,
        transactionType: "INCOME",
        category: category,
        amount: amount,
        description: description,
        transactionAt: transactionAt,
      );

      // Refresh total income and balance after adding income
      await getTotalIncome();
      await getBalance();
      await getRecentTransactions();

      _addIncomeState = DashboardState.success;
    } catch (e) {
      _addIncomeError = e.toString();
      _addIncomeState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> transfer({
    required double amount,
    required int recipientId,
    String description = "",
  }) async {
    _transferState = DashboardState.loading;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      await _dashboardService.transfer(
          token: token,
          amount: amount,
          description: description,
          recipientId: recipientId);

      // Refresh total income and balance after adding income
      await getTotalExpense();
      await getBalance();
      await getRecentTransactions();

      _transferState = DashboardState.success;
    } catch (e) {
      _addIncomeError = e.toString();
      _transferState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addExpense({
    required String category,
    required double amount,
    required DateTime transactionAt,
    String description = "",
  }) async {
    _addExpenseState = DashboardState.loading;
    notifyListeners();

    try {
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

      await _dashboardService.addTransaction(
        token: token,
        transactionType: "EXPENSE",
        category: category,
        amount: amount,
        description: description,
        transactionAt: transactionAt,
      );

      // Refresh total expense and balance after adding expense
      await getTotalExpense();
      await getBalance();
      await getRecentTransactions();

      _addExpenseState = DashboardState.success;
    } catch (e) {
      _addExpenseError = e.toString();
      _addExpenseState = DashboardState.error;
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    // Reset states
    _balanceState = DashboardState.initial;
    _recentTransactionsState = DashboardState.initial;
    _totalExpenseState = DashboardState.initial;
    _totalIncomeState = DashboardState.initial;

    // Reset error messages
    _balanceError = null;
    _recentTransactionsError = null;
    _totalExpenseError = null;
    _totalIncomeError = null;

    // Reset data
    _balance = null;
    _recentTransactions.clear();
    _totalExpense = null;
    _totalIncome = null;

    notifyListeners();
  }
}
