import 'package:flutter/material.dart';
import '../data/models/message_response.dart';
import '../services/auth_services.dart';

enum RegistrationState { initial, loading, loaded, error }

class RegistrationProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  MessageResponse? _registrationResponse;
  RegistrationState _state = RegistrationState.initial;
  String? _errorMessage;

  MessageResponse? get loginResponse => _registrationResponse;
  RegistrationState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> registration(String username, String email, String password,
      String confirmPassword) async {
    _state = RegistrationState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.registrationUser(
          email: email,
          username: username,
          password: password,
          confirmNewPassword: confirmPassword);

      if (response != null) {
        _registrationResponse = response;
        _state = RegistrationState.loaded;
      }
    } catch (e) {
      _errorMessage = e.toString(); // Hapus prefix "Exception: "
      _state = RegistrationState.error;
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _registrationResponse = null;
    _state = RegistrationState.initial;
    notifyListeners();
  }
}
