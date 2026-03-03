import 'package:flutter_riverpod/legacy.dart';
import '../models/mr.dart';

class ProfileNotifier extends StateNotifier<MedicalRepresentative?> {
  ProfileNotifier()
      : super(
          MedicalRepresentative(
            id: '1',
            name: 'Rajdeep Dey',
            phone: '+880 1234567890',
            email: 'rajdeep.dey@medorica.com',
            designation: 'Senior Medical Representative',
            territory: 'Dhaka Division',
            profileImage: null,
            bankAccountNo: '1234567890',
            bankName: 'Dhaka Bank',
            branchName: 'Gulshan Branch',
            ifscCode: 'DKB0001234',
            password: 'password123',
          ),
        );

  void updateProfile(MedicalRepresentative profile) {
    state = profile;
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
}
