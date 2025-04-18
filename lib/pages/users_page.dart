import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media/helper_functions.dart';
import 'package:social_media/widgets/appBatTextWIdget.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarText(appBarTitleText: 'Users'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          //if still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //if has error
          if (snapshot.hasError) {
            showSnackBar(context, snapshot.error.toString());
          }
          // is snapshot has data...
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> individualUser =
                    snapshot.data!.docs[index].data();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: ListTile(
                    title: Text(
                      individualUser['userName'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      DateFormat.yMMMd().add_jm().format(
                            (individualUser['createdAt'] as Timestamp).toDate(),
                          ),
                    ),
                    //add friend
                    trailing: GestureDetector(
                        onTap: () {}, child: const Icon(Icons.person_add)),
                  ),
                );
              },
            );
          }
          return const Text("No User yet...");
        },
      ),
    );
  }
}
