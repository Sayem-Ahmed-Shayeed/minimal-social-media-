import 'package:flutter/material.dart';

class RecentPostText extends StatelessWidget {
  const RecentPostText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            "Recent Posts",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary.withValues(
                    alpha: 0.5,
                  ),
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }
}
