import 'package:flutter/material.dart';
import 'package:social_media/widgets/appBatTextWIdget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarText(appBarTitleText: 'Users'),
      ),
      body: Center(
        child: Text("Users page"),
      ),
    );
  }
}
