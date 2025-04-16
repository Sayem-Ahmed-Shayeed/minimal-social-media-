import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media/provider/light_dark_mode_provider.dart';

import '../helper_functions.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                  child: Icon(Icons.favorite),
                ),
                GestureDetector(
                  onTap: () {
                    //Since wer are already in the homepage so we can just pop the drawer
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.home),
                    title: Text('H O M E'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'profile_page');
                  },
                  child: const ListTile(
                    leading: Icon(Icons.person),
                    title: Text('P R O F I L E'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, 'users_page');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.group,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    title: const Text('U S E R S'),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        ref
                            .watch(
                                LightDarkModeProviderNotifierProvider.notifier)
                            .toggleMode();
                      },
                      child: ListTile(
                        leading: Consumer(
                          builder: (context, ref, child) {
                            return Icon(
                              ref.read(LightDarkModeProviderNotifierProvider) ==
                                      false
                                  ? Icons.dark_mode
                                  : Icons.sunny,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            );
                          },
                        ),
                        title:
                            ref.read(LightDarkModeProviderNotifierProvider) ==
                                    false
                                ? const Text('D A R K  M O D E')
                                : const Text("L I G H T  M O D E"),
                      ),
                    );
                  },
                ),
              ],
            ),
            //log out button
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 50),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  logout(context);
                },
                child: const ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('L O G  O U T'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
