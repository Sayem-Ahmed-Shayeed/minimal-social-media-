import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/widgets/appBatTextWIdget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  String? _userEmail;
  String? _userName;

  @override
  void initState() {
    fetchCurrentUserInfo();
    super.initState();
  }

  // Fetch the current user's info from Firestore using FirebaseAuth email as the document id.
  void fetchCurrentUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();
      setState(() {
        _userEmail = userDoc['email'];
        _userName = userDoc['userName'];
      });
    }
  }

  // Delete a post.
  void deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  // Toggle like for a post.
  // Uses GestureDetector on double tap and onTap within the reaction row.
  void toggleLike(String postId, List likes) async {
    if (_userName == null) return;
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    if (likes.contains(_userName)) {
      await postRef.update({
        'likes': FieldValue.arrayRemove([_userName])
      });
    } else {
      await postRef.update({
        'likes': FieldValue.arrayUnion([_userName])
      });
    }
  }

  // Scroll to the top of the post list.
  void scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubicEmphasized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarText(appBarTitleText: "Profile Page"),
      ),
      floatingActionButton: Positioned(
        child: GestureDetector(
          onTap: scrollToTop,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: const Icon(Icons.arrow_upward, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            //add the profile icons here
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                borderRadius: BorderRadius.circular(200),
              ),
              child: const Icon(
                Icons.person,
                size: 80,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _userName ?? 'Loading...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary
                    .withValues(alpha: 0.7),
              ),
            ),
            Text(
              _userEmail ?? 'Loading...',
              style: TextStyle(
                fontSize: 15,
                color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(
              width: 100,
              child: Divider(),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Posts",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(
              width: 50,
              child: Divider(),
            ),
            // Posts list retrieved in real time
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                // if (context.mounted) Navigator.pop(context);
                final posts = snapshot.data!.docs.where((doc) {
                  final post = doc.data();
                  return post['userEmail'] == _userEmail;
                }).toList();
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final postId = post['postId'];
                    final content = post['content'];
                    final author = post['userName'];
                    final likes = List.from(post['likes']);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: GestureDetector(
                        // Allow double-tap to like
                        onDoubleTap: () => toggleLike(postId, likes),
                        child: Container(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .surface,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row with icon, author name and popup menu at top-right
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.person, size: 40),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          // Wrap author name if long
                                          Text(
                                            author,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(content),
                                          const SizedBox(height: 10),
                                          // Reaction row: like and comment counts next to their icons
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    toggleLike(postId, likes),
                                                child: Icon(
                                                  Icons.favorite,
                                                  color:
                                                  likes.contains(_userName)
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Text('${likes.length}'),
                                              const SizedBox(width: 20),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
