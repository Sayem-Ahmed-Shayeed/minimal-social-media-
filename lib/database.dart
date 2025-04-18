import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final postRef = FirebaseFirestore.instance.collection('posts');

  // 📝 Add Post
  Future<void> addPost({
    required String userName,
    required String postText,
  }) async {
    final postId = postRef.doc().id;
    await postRef.doc(postId).set({
      'postId': postId,
      'userName': userName,
      'content': postText,
      'createdAt': Timestamp.now(),
      'likes': [],
      'commentsCount': 0,
    });
  }

  // ✏️ Edit Post
  Future<void> editPost({
    required String postId,
    required String newContent,
  }) async {
    await postRef.doc(postId).update({
      'content': newContent,
    });
  }

  // ❌ Delete Post
  Future<void> deletePost(String postId) async {
    await postRef.doc(postId).delete();
  }

  // 👍 Like
  Future<void> addLike({
    required String postId,
    required String userName,
  }) async {
    await postRef.doc(postId).update({
      'likes': FieldValue.arrayUnion([userName])
    });
  }

  // 👎 Unlike
  Future<void> removeLike({
    required String postId,
    required String userName,
  }) async {
    await postRef.doc(postId).update({
      'likes': FieldValue.arrayRemove([userName])
    });
  }

  // 💬 Add Comment or Reply
  Future<void> addCommentOrReply({
    required String postId,
    required String userName,
    required String text,
    String? parentId, // null means it's a top-level comment
  }) async {
    final commentData = {
      'userName': userName,
      'text': text,
      'createdAt': Timestamp.now(),
      'parentId': parentId,
    };

    await postRef.doc(postId).collection('comments').add(commentData);

    // Update comment count only for top-level
    if (parentId == null) {
      await postRef.doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });
    }
  }

  // ✏️ Edit Comment or Reply
  Future<void> editCommentOrReply({
    required String postId,
    required String commentId,
    required String newText,
  }) async {
    await postRef
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({'text': newText});
  }

  // 🗑 Delete Comment/Reply Recursively
  Future<void> deleteCommentOrReply({
    required String postId,
    required String commentId,
  }) async {
    final commentsCollection = postRef.doc(postId).collection('comments');

    // Get the comment to check if it's top-level
    final docSnapshot = await commentsCollection.doc(commentId).get();
    final isTopLevel = docSnapshot.data()?['parentId'] == null;

    // Recursive deletion
    Future<void> deleteWithReplies(String id) async {
      final replies =
          await commentsCollection.where('parentId', isEqualTo: id).get();
      for (var doc in replies.docs) {
        await deleteWithReplies(doc.id);
      }
      await commentsCollection.doc(id).delete();
    }

    await deleteWithReplies(commentId);

    if (isTopLevel) {
      await postRef.doc(postId).update({
        'commentsCount': FieldValue.increment(-1),
      });
    }
  }
}
