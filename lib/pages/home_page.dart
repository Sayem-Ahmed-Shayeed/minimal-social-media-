import 'package:flutter/material.dart';
import 'package:social_media/widgets/appBatTextWIdget.dart';

import '../widgets/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarText(
          appBarTitleText: "Home Page",
        ),
      ),
      body: const Center(
        child: Text("Logged in"),
      ),
    );
  }
}
