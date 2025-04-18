import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media/provider/confirm_passwrod_provider.dart';
import 'package:social_media/provider/email_provider.dart';
import 'package:social_media/provider/name_provider.dart';
import 'package:social_media/provider/password_provider.dart';
import 'package:social_media/widgets/myTextField.dart';
import 'package:social_media/widgets/my_button.dart';

import '../helper_functions.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  var inLoginMode = false;

  void clearAllTextField() {
    ref.watch(EmailNotifierProvider.notifier).updateEmail('');
    ref.watch(PasswordProviderNotifierProvider.notifier).updatePassword('');
    ref
        .watch(ConfirmPasswrodNotifierProvider.notifier)
        .updateConfirmPassword('');
    ref.watch(nameNotifierProvider.notifier).updateName('');
  }

  void login() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showCircularProgessIndicator(context); // safe before await

    final email = ref.watch(EmailNotifierProvider);
    final password = ref.watch(PasswordProviderNotifierProvider);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      navigator.pop(); // use saved navigator
    } on FirebaseAuthException catch (e) {
      navigator.pop();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  void signUp() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    //first of all show a circular progess indicator
    showCircularProgessIndicator(context);
    //try to create a user if the confirmPw and pass are smae
    if (ref.read(PasswordProviderNotifierProvider) ==
        ref.read(ConfirmPasswrodNotifierProvider)) {
      String email = ref.read(EmailNotifierProvider);
      String password = ref.read(PasswordProviderNotifierProvider);
      try {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (context.mounted) {
          Navigator.pop(context);
        }
        //store the usersList in the firestore database.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(
              ref.read(EmailNotifierProvider),
            )
            .set({
          'userName': ref.read(nameNotifierProvider),
          'email': ref.read(EmailNotifierProvider),
          'createdAt': DateTime.now(),
        });

        //if we success to create then we just stop the loading spinner

        //catch any exceptions if found
      } on FirebaseAuthException catch (e) {
        //pop the circular progess indicator
        navigator.pop();
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(e.message ?? 'SignUp failed')),
        );
      }
    } else {
      Navigator.pop(context);
      showSnackBar(context, 'Password did not matched');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                Text(
                  'SOCIAL',
                  style: TextStyle(
                    letterSpacing: 3,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                if (!inLoginMode)
                  const MyTextField(
                    hintText: 'Name',
                    shouldBeObscure: false,
                  ),
                const SizedBox(
                  height: 10,
                ),
                const MyTextField(
                  hintText: 'Email',
                  shouldBeObscure: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                const MyTextField(
                  hintText: 'Password',
                  shouldBeObscure: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!inLoginMode)
                  const MyTextField(
                    hintText: 'Confirm password',
                    shouldBeObscure: true,
                  ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Sign in button here
                MyButton(
                  onTap: inLoginMode ? login : signUp,
                  text: inLoginMode ? "LOGIN" : "REGISTER",
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      inLoginMode
                          ? "Don\'t have an account?"
                          : "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          inLoginMode = !inLoginMode;
                          clearAllTextField();
                        });
                      },
                      child: Text(
                        inLoginMode ? "REGISTER" : "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
