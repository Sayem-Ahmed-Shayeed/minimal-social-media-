import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/profile_provider.dart';

class ProifileItems extends StatelessWidget {
  final String itemTitle;
  final int index;

  const ProifileItems({
    super.key,
    required this.itemTitle,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        int selectedIndex = ref.watch(ProfileProviderNotifierProvider);
        return GestureDetector(
          onTap: () {
            ref
                .watch(ProfileProviderNotifierProvider.notifier)
                .updateIndex(index);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              itemTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      index == selectedIndex ? Colors.pink : Colors.blueGrey),
            ),
          ),
        );
      },
    );
  }
}
