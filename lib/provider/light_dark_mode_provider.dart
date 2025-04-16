import 'package:flutter_riverpod/flutter_riverpod.dart';

final LightDarkModeProviderNotifierProvider =
    StateNotifierProvider<LightDarkModeProviderNotifier, bool>((ref) {
  return LightDarkModeProviderNotifier();
});

class LightDarkModeProviderNotifier extends StateNotifier<bool> {
  LightDarkModeProviderNotifier() : super(false);

  void toggleMode() {
    state = state = !state;
  }
}
