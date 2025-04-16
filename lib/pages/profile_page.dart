import 'package:flutter/material.dart';

import '../widgets/appBatTextWIdget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppBarText(appBarTitleText: 'Profile'),
      ),
      body: Center(
        child: Text("Profile page"),
      ),
    );
  }
}
