import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameNotifierProvider = StateNotifierProvider<nameNotifier, String>((ref) {
  return nameNotifier();
});

class nameNotifier extends StateNotifier<String> {
  nameNotifier() : super('');

  void updateName(String name) {
    state = state = name;
  }
}
