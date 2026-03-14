import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mr.dart';
import '../services/auth/auth_services.dart';

class _AuthPrefsKeys {
  static const String isLoggedIn = 'auth_is_logged_in';
  static const String mrId = 'auth_mr_id';
  static const String fullName = 'auth_full_name';
  static const String phoneNo = 'auth_phone_no';
}

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final MedicalRepresentative? mr;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.mr,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    MedicalRepresentative? mr,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      mr: mr ?? this.mr,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(AuthState());

  final AuthService _authService;

  Future<void> login(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final AuthLoginResponse response = await _authService.login(
        phoneNo: phone,
        password: password,
      );

      final MedicalRepresentative mr = MedicalRepresentative(
        id: response.mrId,
        mrId: response.mrId,
        name: response.fullName,
        phone: response.phoneNo,
        email: '',
        designation: 'Medical Representative',
        territory: '',
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        mr: mr,
        error: null,
      );

      await _saveSession(mr);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<bool> restoreSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool loggedIn = prefs.getBool(_AuthPrefsKeys.isLoggedIn) ?? false;
      if (!loggedIn) {
        return false;
      }

      final String mrId = prefs.getString(_AuthPrefsKeys.mrId) ?? '';
      if (mrId.isEmpty) {
        return false;
      }

      final MedicalRepresentative mr = MedicalRepresentative(
        id: mrId,
        mrId: mrId,
        name: prefs.getString(_AuthPrefsKeys.fullName) ?? '',
        phone: prefs.getString(_AuthPrefsKeys.phoneNo) ?? '',
        email: '',
        designation: 'Medical Representative',
        territory: '',
      );

      state = state.copyWith(
        isAuthenticated: true,
        mr: mr,
        isLoading: false,
        error: null,
      );

      return true;
    } on PlatformException {
      // If plugin channel is not ready, continue with logged-out state.
      return false;
    }
  }

  Future<void> logout() async {
    await _clearSession();
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setCurrentMr(MedicalRepresentative mr) {
    state = state.copyWith(mr: mr, isAuthenticated: true);
    _saveSession(mr);
  }

  Future<void> _saveSession(MedicalRepresentative mr) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_AuthPrefsKeys.isLoggedIn, true);
      await prefs.setString(_AuthPrefsKeys.mrId, mr.mrId);
      await prefs.setString(_AuthPrefsKeys.fullName, mr.name);
      await prefs.setString(_AuthPrefsKeys.phoneNo, mr.phone);
    } on PlatformException {
      // Ignore persistence failures; user remains logged in for current session.
    }
  }

  Future<void> _clearSession() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_AuthPrefsKeys.isLoggedIn);
      await prefs.remove(_AuthPrefsKeys.mrId);
      await prefs.remove(_AuthPrefsKeys.fullName);
      await prefs.remove(_AuthPrefsKeys.phoneNo);
    } on PlatformException {
      // Ignore clear failures.
    }
  }
}
