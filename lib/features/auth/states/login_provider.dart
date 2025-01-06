import 'package:flutter/material.dart';
import '../../../core/utils/shared_preferences_helper.dart';
import '../data/models/login_response.dart';
import '../services/auth_services.dart';

enum LoginState { initial, loading, success, error }

class LoginProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  LoginResponse? _loginResponse;
  LoginState _state = LoginState.initial;
  String? _errorMessage;

  LoginResponse? get loginResponse => _loginResponse;
  LoginState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> login(String identifier, String password) async {
    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final LoginResponse? response = await _authService.loginUser(
        identifier: identifier,
        password: password,
      );

      if (response == null) throw "Token tidak didapatkan";

      _loginResponse = response;
      String token = _loginResponse?.token ?? "";

      await SharedPreferencesHelper.setAuthToken(token);
      _state = LoginState.success;
    } catch (e) {
      _errorMessage = e.toString(); // Hapus prefix "Exception: "
      _state = LoginState.error;
    } finally {
      notifyListeners();
    }
  }

  void logout() {
    _loginResponse = null;
    _state = LoginState.initial;
    notifyListeners();
  }
}
