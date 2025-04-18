import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/widgets/appBatTextWIdget.dart';
import 'package:social_media/widgets/my_drawer.dart';

import '../widgets/my_post_button.dart';
import '../widgets/post_Text_field.dart';
import '../widgets/recent_post_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _postController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _editingPostId;
  String? _userEmail;
  String? _userName;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserInfo();
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

  // Handle post creation or editing.
  void handlePost() async {
    if (_postController.text.trim().isEmpty ||
        _userEmail == null ||
        _userName == null) return;

    if (_editingPostId == null) {
      final postId = FirebaseFirestore.instance.collection('posts').doc().id;
      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        'postId': postId,
        'userEmail': _userEmail,
        'userName': _userName,
        'content': _postController.text.trim(),
        'createdAt': Timestamp.now(),
        'likes': [],
        'commentsCount': 0,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(_editingPostId)
          .update({
        'content': _postController.text.trim(),
      });
    }

    setState(() {
      _editingPostId = null;
      _postController.clear();
    });
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
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const AppBarText(appBarTitleText: "Home Page"),
      ),
      // Floating button placed in the center at the bottom
      floatingActionButton: Positioned(
        bottom: 0,
        left: MediaQuery.of(context).size.width / 2 - 20,
        child: GestureDetector(
          onTap: scrollToTop,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Post input field (scrolls with the posts)
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                  child: PostTextField(
                    controller: _postController,
                    hintText: _editingPostId == null
                        ? 'Post your intrusive thought...'
                        : 'Edit your post...',
                  ),
                ),
                const SizedBox(height: 10),
                // Post button
                GestureDetector(
                  onTap: handlePost,
                  child: const MyPostButton(),
                ),
                const SizedBox(height: 10),
                const RecentPostText(),
                // Posts list retrieved in real time
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final posts = snapshot.data!.docs;
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
                        final postUserEmail = post['userEmail'];
                        final isAuthor = _userEmail == postUserEmail;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: GestureDetector(
                            // Allow double-tap to like
                            onDoubleTap: () => toggleLike(postId, likes),
                            child: Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row with icon, author name and popup menu at top-right
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    onTap: () => toggleLike(
                                                        postId, likes),
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: likes.contains(
                                                              _userName)
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
                                        if (isAuthor)
                                          // PopupMenuButton for edit/delete at top right
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                setState(() {
                                                  scrollToTop();
                                                  _editingPostId = postId;
                                                  _postController.text =
                                                      content;
                                                });
                                              } else if (value == 'delete') {
                                                deletePost(postId);
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
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
        ],
      ),
    );
  }
}
