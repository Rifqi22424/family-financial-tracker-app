import 'package:financial_family_tracker/features/auth/data/models/verification_response.dart';
import 'package:flutter/material.dart';
import 'package:financial_family_tracker/core/utils/shared_preferences_helper.dart';
import '../services/auth_services.dart';

enum VerificationState { initial, loading, success, error }

class VerificationProvider with ChangeNotifier {
  final AuthService _verificationService = AuthService();
  VerificationState _state = VerificationState.initial;
  String? _errorMessage;
  VerificationResponse? _response;

  VerificationState get state => _state;
  String? get errorMessage => _errorMessage;
  VerificationResponse? get response => _response;

  Future<void> verifyEmail(String email, String verificationCode) async {
    _state = VerificationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Get token from SharedPreferences
      final VerificationResponse response =
          await _verificationService.verifyEmail(
        email: email,
        verificationCode: verificationCode,
      );

      _response = response;

      String token = _response?.token ?? "";
      if (token == "") throw "Token tidak didapaktkan";

      await SharedPreferencesHelper.setAuthToken(token);

      _state = VerificationState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = VerificationState.error;
    } finally {
      notifyListeners();
    }
  }

  void resetState() {
    _state = VerificationState.initial;
    _errorMessage = null;
    _response = null;
    notifyListeners();
  }
}
