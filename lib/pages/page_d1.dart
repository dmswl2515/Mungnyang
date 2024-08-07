import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:totalexam/controllers/user_controller.dart';
import 'package:totalexam/pages/editpage2.dart';
import '../reference/drawer.dart';
import 'page_d2.dart';

class PageD1 extends StatelessWidget {
  const PageD1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _userController = Get.put(UserController());
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        title: const Text('육묘일기'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Get.to(() => PageD2());
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('게시물이 없습니다.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final postId = posts[index].id; // Get the document ID

              return Card(
                color: const Color.fromARGB(0, 255, 193, 7),
                elevation: 0,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.black12, // Light gray color
                        thickness: 1, // Line thickness
                        height: 1, // Space above and below the line
                      ),
                      // Profile section
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage(
                                _userController.userProfileImage.value,
                              ),
                              backgroundColor: Colors.amber,
                              child: SizedBox(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    _userController.userProfileImage.value,
                                  ),
                                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 1),
                          Text(
                            "김은지",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Spacer(),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert),
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _editPost(context, postId);
                                  break;
                                case 'delete':
                                  _deletePost(postId);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return {'edit', 'delete'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice == 'edit' ? '수정' : '삭제'),
                                );
                              }).toList();
                            },
                          ),
                        ],
                      ),
                      // 이미지
                      ClipRect(
                        child: Align(
                          alignment: Alignment.center,
                          heightFactor: 1.0,
                          widthFactor: 1.0,
                          child: Image.network(
                            post['image'],
                            fit: BoxFit.fill,
                            height: 350, // Adjust height as needed
                            width: double.infinity, // Full width
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            // LikeButton widget from the likebutton package
                            LikeButton(
                              size: 24,
                              isLiked: post.containsKey('isLiked')
                                  ? post['isLiked']
                                  : false,
                              likeCount:
                                  post.containsKey('likes') ? post['likes'] : 0,
                              onTap: (isLiked) async {
                                // Handle like button tap
                                _toggleLike(postId, isLiked);
                                return !isLiked;
                              },
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 0,
                              child: Text(
                                '${post.containsKey('likes') ? post['likes'] : 0} likes',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          post['title'] ?? 'No Title',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          post['note'] ?? 'No Note',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[800]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          height: 0,
                          child: Text(
                            '${post['date']?.toDate() ?? 'No Date'}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${post['startTime'] ?? 'No Time'}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Divider between post and end of card
                      Divider(
                        color: Colors.black12, // Light gray color
                        thickness: 1, // Line thickness
                        height: 20, // Space above and below the line
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editPost(BuildContext context, String postId) {
    Get.to(() => EditPage2(postId: postId));
  }

  void _deletePost(String postId) {
    FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  void _toggleLike(String postId, bool isLiked) async {
    // Toggle the like state and update Firestore
    final postDoc = FirebaseFirestore.instance.collection('posts').doc(postId);
    final postSnapshot = await postDoc.get();

    if (postSnapshot.exists) {
      final postData = postSnapshot.data() as Map<String, dynamic>;
      final currentLikes = postData['likes'] ?? 0;

      // Increment or decrement the likes based on the current like state
      final newLikes = isLiked ? currentLikes - 1 : currentLikes + 1;

      await postDoc.update({
        'likes': newLikes,
        'isLiked': !isLiked, // Update the like status
      });
    }
  }
}
