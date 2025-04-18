import 'package:flutter/material.dart';

class MyPostButton extends StatelessWidget {
  const MyPostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(
        top: 0,
        left: 25,
        right: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.pink.shade500,
      ),
      child: const Center(
        child: Text(
          "Post",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
