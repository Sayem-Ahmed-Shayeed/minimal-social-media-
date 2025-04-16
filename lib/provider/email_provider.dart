import 'package:flutter_riverpod/flutter_riverpod.dart';

final EmailNotifierProvider =
    StateNotifierProvider<EmailNotifier, String>((ref) {
  return EmailNotifier();
});

class EmailNotifier extends StateNotifier<String> {
  EmailNotifier() : super('');

  void updateEmail(String email) {
    state = email;
    state = state;
  }
}
