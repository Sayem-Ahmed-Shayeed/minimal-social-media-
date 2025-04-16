import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  final String appBarTitleText;

  const AppBarText({super.key, required this.appBarTitleText});

  @override
  Widget build(BuildContext context) {
    return Text(
      appBarTitleText,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        letterSpacing: 2,
      ),
    );
  }
}
