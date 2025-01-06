  import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
  import 'package:flutter/material.dart';
  import '../../auth/data/models/message_response.dart';
  import '../services/family_services.dart';

  enum JoinFamilyState { initial, loading, success, error }

  class JoinFamilyProvider with ChangeNotifier {
    final FamilyService _familyService = FamilyService();
    JoinFamilyState _state = JoinFamilyState.initial;
    String? _errorMessage;
    MessageResponse? _response;

    JoinFamilyState get state => _state;
    String? get errorMessage => _errorMessage;
    MessageResponse? get response => _response;

    Future<void> joinFamily(String familyCode, String role) async {
      _state = JoinFamilyState.loading;
      _errorMessage = null;
      notifyListeners();

      try {
        // Ambil token dari SharedPreferences
        final String? token = await SharedPreferencesHelper.getAuthToken();
        if (token == null) {
          throw Exception("Token tidak ditemukan. Silakan login ulang.");
        }

        final response = await _familyService.joinFamily(
          familyCode: familyCode,
          role: role,
          token: token,
        );

        _response = response;
        _state = JoinFamilyState.success;
      } catch (e) {
        _errorMessage = e.toString();
        _state = JoinFamilyState.error;
      } finally {
        notifyListeners();
      }
    }

    void resetState() {
      _state = JoinFamilyState.initial;
      _errorMessage = null;
      _response = null;
      notifyListeners();
    }
  }
