import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/profile_notifier.dart';
import '../models/mr.dart';
import '../services/profile/profile_services.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, MedicalRepresentative?>((ref) {
      return ProfileNotifier(ref.read(profileServiceProvider), ref.read);
    });
