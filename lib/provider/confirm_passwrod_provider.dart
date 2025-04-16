import 'package:flutter_riverpod/flutter_riverpod.dart';

final ConfirmPasswrodNotifierProvider =
    StateNotifierProvider<ConfirmPasswrodProviderNotifier, String>((ref) {
  return ConfirmPasswrodProviderNotifier();
});

class ConfirmPasswrodProviderNotifier extends StateNotifier<String> {
  ConfirmPasswrodProviderNotifier() : super('');

  void updateConfirmPassword(String confirmPw) {
    state = state = confirmPw;
  }
}
