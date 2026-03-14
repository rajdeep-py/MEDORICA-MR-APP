import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';
import '../models/mr.dart';
import '../provider/auth_provider.dart';
import '../services/profile/profile_services.dart';

typedef Reader = T Function<T>(ProviderListenable<T> provider);

class ProfileNotifier extends StateNotifier<MedicalRepresentative?> {
  ProfileNotifier(this._profileService, this._read) : super(null);

  final ProfileService _profileService;
  final Reader _read;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCurrentMrProfile() async {
    final String? mrId = _read(authNotifierProvider).mr?.mrId;
    if (mrId == null || mrId.isEmpty) {
      _error = 'No logged in MR found';
      return;
    }
    await fetchProfileByMrId(mrId);
  }

  Future<void> fetchProfileByMrId(String mrId) async {
    _isLoading = true;
    _error = null;
    try {
      final MedicalRepresentative profile = await _profileService
          .fetchProfileByMrId(mrId);
      state = profile;
      _read(authNotifierProvider.notifier).setCurrentMr(profile);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  void updateProfile(MedicalRepresentative profile) {
    state = profile;
    _read(authNotifierProvider.notifier).setCurrentMr(profile);
  }

  void updateProfileImage(String imagePath) {
    if (state != null) {
      state = state!.copyWith(profileImage: imagePath);
    }
  }

  void updatePhone(String phone) {
    if (state != null) {
      state = state!.copyWith(phone: phone);
    }
  }

  void updateEmail(String email) {
    if (state != null) {
      state = state!.copyWith(email: email);
    }
  }

  void updateName(String name) {
    if (state != null) {
      state = state!.copyWith(name: name);
    }
  }

  void updateBankDetails({
    required String accountNo,
    required String bankName,
    required String branchName,
    required String ifscCode,
  }) {
    if (state != null) {
      state = state!.copyWith(
        bankAccountNo: accountNo,
        bankName: bankName,
        branchName: branchName,
        ifscCode: ifscCode,
      );
    }
  }

  void updatePassword(String password) {
    if (state != null) {
      state = state!.copyWith(password: password);
    }
  }

  void updateAllDetails({
    required String name,
    required String phone,
    required String email,
    required String bankAccountNo,
    required String bankName,
    required String branchName,
    required String ifscCode,
    String? password,
  }) {
    if (state != null) {
      state = state!.copyWith(
        name: name,
        phone: phone,
        email: email,
        bankAccountNo: bankAccountNo,
        bankName: bankName,
        branchName: branchName,
        ifscCode: ifscCode,
        password: password,
      );
    }
  }

  Future<void> updateCurrentMrProfile({
    required String name,
    required String phone,
    required String email,
    required String bankAccountNo,
    required String bankName,
    required String branchName,
    required String ifscCode,
    String? password,
    String? profilePhotoPath,
  }) async {
    final MedicalRepresentative? current = state;
    if (current == null) {
      throw Exception('Profile is not loaded');
    }

    _isLoading = true;
    _error = null;

    try {
      final MedicalRepresentative updated = await _profileService
          .updateProfileByMrId(
            mrId: current.mrId,
            fullName: name,
            phoneNo: phone,
            password: (password != null && password.trim().isNotEmpty)
                ? password
                : (current.password ?? ''),
            altPhoneNo: current.altPhoneNo,
            email: email,
            address: current.address,
            joiningDate: current.joiningDate,
            bankName: bankName,
            bankAccountNo: bankAccountNo,
            ifscCode: ifscCode,
            branchName: branchName,
            active: current.active,
            profilePhotoPath: profilePhotoPath,
          );

      state = updated;
      _read(authNotifierProvider.notifier).setCurrentMr(updated);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
