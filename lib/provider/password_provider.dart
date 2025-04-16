import 'package:flutter_riverpod/flutter_riverpod.dart';

final PasswordProviderNotifierProvider =
    StateNotifierProvider<PasswordProviderNotifier, String>((ref) {
  return PasswordProviderNotifier();
});

class PasswordProviderNotifier extends StateNotifier<String> {
  PasswordProviderNotifier() : super('');

  void updatePassword(String password) {
    state = password;
    state = state;
  }
}
