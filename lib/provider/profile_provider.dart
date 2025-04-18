import 'package:flutter_riverpod/flutter_riverpod.dart';

final ProfileProviderNotifierProvider =
    StateNotifierProvider<ProfileProviderNotifier, int>((ref) {
  return ProfileProviderNotifier();
});

class ProfileProviderNotifier extends StateNotifier<int> {
  ProfileProviderNotifier() : super(0);

  void updateIndex(int index) {
    state = state = index;
  }
}
