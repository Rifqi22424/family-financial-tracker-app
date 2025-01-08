import 'package:flutter/material.dart';
import '../data/models/message_response.dart';
import '../services/auth_services.dart';

enum PasswordState { initial, loading, success, error }

class PasswordProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  PasswordState _state = PasswordState.initial;
  MessageResponse? _changePasswordResponse;
  String? _errorMessage;

  // Getters
  PasswordState get state => _state;
  MessageResponse? get changePasswordResponse => _changePasswordResponse;
  String? get errorMessage => _errorMessage;

  /// Fungsi untuk mengubah password
  Future<void> changePassword({
    required String identifier,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _state = PasswordState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.changePassword(
        identifier: identifier,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      if (response != null) {
        _changePasswordResponse = response;
        _state = PasswordState.success;
      } else {
        _state = PasswordState.error;
        _errorMessage = "Unexpected error occurred";
      }
    } catch (e) {
      _state = PasswordState.error;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Reset state untuk digunakan kembali
  void resetState() {
    _state = PasswordState.initial;
    _changePasswordResponse = null;
    _errorMessage = null;
    notifyListeners();
  }
}
