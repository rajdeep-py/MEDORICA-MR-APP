import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/mr.dart';
import '../notifiers/profile_notifier.dart';
import '../services/profile/profile_services.dart';
import '../services/salary_slip/salary_slip_services.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final salarySlipServiceProvider = Provider<SalarySlipServices>((ref) {
  return SalarySlipServices();
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, MedicalRepresentative?>((ref) {
      return ProfileNotifier(
        ref.read(profileServiceProvider),
        ref.read,
        ref.read(salarySlipServiceProvider),
      );
    });
