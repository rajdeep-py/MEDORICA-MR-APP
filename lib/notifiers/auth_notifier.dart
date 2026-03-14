import 'package:flutter_riverpod/legacy.dart';
import '../models/mr.dart';
import '../services/auth/auth_services.dart';

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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
    }
  }

  void logout() {
    state = AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setCurrentMr(MedicalRepresentative mr) {
    state = state.copyWith(mr: mr, isAuthenticated: true);
  }
}
