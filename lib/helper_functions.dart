import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    ),
  );
}

//circular progess indicator
void showCircularProgessIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

//logout function
void logout(BuildContext context) {
  showCircularProgessIndicator(context);
  FirebaseAuth.instance.signOut();
  Navigator.pop(context);
}
