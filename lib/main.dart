import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media/pages/auth.dart';
import 'package:social_media/pages/home_page.dart';
import 'package:social_media/pages/login_page.dart';
import 'package:social_media/pages/profile_page.dart';
import 'package:social_media/pages/users_page.dart';
import 'package:social_media/provider/light_dark_mode_provider.dart';
import 'package:social_media/theme/dark_mode.dart';
import 'package:social_media/theme/light_mode.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool inDarkMode = ref.watch(LightDarkModeProviderNotifierProvider);
    return MaterialApp(
      routes: {
        'profile_page': (context) => const ProfilePage(),
        'users_page': (context) => const UsersPage(),
        'home_page': (context) => const HomePage(),
        'login_page': (context) => const LoginPage(),
      },
      theme: lightMode,
      themeMode: inDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: darkMode,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: AuthPage(),
      ),
    );
  }
}
