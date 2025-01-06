import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import '../../auth/data/models/message_response.dart';
import '../services/family_services.dart';

enum CreateFamilyState { initial, loading, success, error }

class CreateFamilyProvider with ChangeNotifier {
  final FamilyService _familyService = FamilyService();
  CreateFamilyState _state = CreateFamilyState.initial;
  String? _errorMessage;
  MessageResponse? _response;

  CreateFamilyState get state => _state;
  String? get errorMessage => _errorMessage;
  MessageResponse? get response => _response;

  Future<void> createFamily(String familyName, String role) async {
    _state = CreateFamilyState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Ambil token dari SharedPreferences
      final String? token = await SharedPreferencesHelper.getAuthToken();
      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final response = await _familyService.createFamily(
        name: familyName,
        role: role,
        token: token,
      );

      _response = response;
      _state = CreateFamilyState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = CreateFamilyState.error;
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = CreateFamilyState.initial;
    _errorMessage = null;
    _response = null;
    notifyListeners();
  }
}
