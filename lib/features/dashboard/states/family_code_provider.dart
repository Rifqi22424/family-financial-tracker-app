import 'package:flutter/material.dart';
import '../../../core/utils/shared_preferences_helper.dart';
import '../../family/services/family_services.dart';

enum FamilyCodeState { initial, loading, success, error }

class FamilyCodeProvider with ChangeNotifier {
  final FamilyService _authService = FamilyService();
  FamilyCodeState _state = FamilyCodeState.initial;
  String? _familyCode;
  String? _errorMessage;

  // Getters
  FamilyCodeState get state => _state;
  String? get familyCode => _familyCode;
  String? get errorMessage => _errorMessage;

  /// Fetch the family code
  Future<void> fetchFamilyCode() async {
    _state = FamilyCodeState.loading;
    _errorMessage = null;
    notifyListeners();

    final String? token = await SharedPreferencesHelper.getAuthToken();
    if (token == null) throw "Token tidak ditemukan. Silakan login ulang.";

    try {
      final code = await _authService.fetchFamilyCode(token: token);
      _familyCode = code;
      _state = FamilyCodeState.success;
    } catch (e) {
      _state = FamilyCodeState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Reset state for reuse
  void resetState() {
    _state = FamilyCodeState.initial;
    _familyCode = null;
    _errorMessage = null;
    notifyListeners();
  }
}
