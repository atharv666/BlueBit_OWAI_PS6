import 'package:flutter/material.dart';
import 'package:gmr/models/shared_preferences.dart';
import 'package:gmr/screens/login%20&%20Signup/login1.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String databaseUrl = "https://gmrapp-4da95-default-rtdb.firebaseio.com/";

// Check if the user is logged in
Future<bool> isUserLoggedIn() async {
  String userId = await getUniversalId();
  return userId != 'Sign Up/ Login to view details';
}

// Fetch universalId from SharedPreferences
Future<String> getUniversalId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('universalId') ?? 'Sign Up/ Login to view details';
}

void _showLoginAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Access Denied", style: TextStyle(color: Colors.blue[800])),
      content: Text(message, style: TextStyle(color: Colors.blue[900])),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (ctx) => const LoginScreen()), // Navigates to Login
            );
          },
          child: Text("Login", style: TextStyle(color: Colors.green[700])),
        ),
      ],
    ),
  );
}

// Add Post to Firebase Realtime Database
Future<void> addPost(String title, String description, BuildContext context) async {
  try {
    final url = Uri.parse("$databaseUrl/posts.json");
    String userId = await getUniversalId();
    if (userId != 'Sign Up/ Login to view details') {
      await http.post(
        url,
        body: jsonEncode({
          'title': title,
          'description': description,
          'userId': userId,
          'likes': 0,
          'likedByUser': false, // New field to track likes per user
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } else {
      _showLoginAlert(context, "Please Log In to Add a Post");
    }
  } catch (e) {
    print("Error adding post: $e");
  }
}

// Like/Dislike function with a bool flag
Future<int> toggleLikePost(String postId, int currentLikes) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool liked = prefs.getBool('liked_$postId') ?? false; // Check if user has liked before
    final url = Uri.parse("$databaseUrl/posts/$postId.json");

    int newLikes = liked ? currentLikes - 1 : currentLikes + 1;

    await http.patch(
      url,
      body: jsonEncode({'likes': newLikes}),
    );

    prefs.setBool('liked_$postId', !liked); // Toggle the like state
    return newLikes;
  } catch (e) {
    print("Error toggling like: $e");
    return currentLikes;
  }
}

// Comment on a Post
Future<void> addComment(String postId, String text, BuildContext context) async {
  try {
    final url = Uri.parse("$databaseUrl/posts/$postId/comments.json");
    String userId = await getUniversalId();
    if (userId != 'Sign Up/ Login to view details') {
      await http.post(
        url,
        body: jsonEncode({
          'userId': userId,
          'text': text,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    } else {
      _showLoginAlert(context, "Please Log In to Comment on the Post");
    }
  } catch (e) {
    print("Error adding comment: $e");
  }
}

class CommunityForum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Discussion", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PostList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostDialog(context),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showPostDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create a Post", style: TextStyle(color: Colors.blue[800])),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.blue[800]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                addPost(titleController.text, descriptionController.text, context);
                Navigator.pop(context);
              },
              child: Text("Post", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<Map<String, dynamic>> posts = [];
  Map<String, List<Map<String, dynamic>>> comments = {};
  Set<String> reportedPosts = {}; // Track reported posts

  Future<void> fetchPosts() async {
    try {
      final url = Uri.parse("$databaseUrl/posts.json");
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != "null") {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          posts = data.entries.map((entry) {
            return {
              'id': entry.key,
              'title': entry.value['title'],
              'description': entry.value['description'],
              'likes': entry.value['likes'],
            };
          }).toList();
        });

        for (var post in posts) {
          fetchComments(post['id']);
        }
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> fetchComments(String postId) async {
    try {
      final url = Uri.parse("$databaseUrl/posts/$postId/comments.json");
      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != "null") {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          comments[postId] = data.entries.map((entry) {
            return {
              'userId': entry.value['userId'],
              'text': entry.value['text'],
            };
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching comments: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return posts.isEmpty
        ? Center(child: CircularProgressIndicator(color: Colors.blue[800]))
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              bool isReported = reportedPosts.contains(post['id']); // Check if reported
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[50]!, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Title in Bold
                        Text(
                          post['title'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800]),
                        ),
                        SizedBox(height: 10),
                        Text(post['description'], style: TextStyle(color: Colors.blue[900])),
                        SizedBox(height: 15),

                        // Like & Comment buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<bool>(
                              future: _hasLikedPost(post['id']),
                              builder: (context, snapshot) {
                                bool liked = snapshot.data ?? false;
                                return Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.thumb_up, color: liked ? Colors.blue[800] : Colors.grey),
                                      onPressed: () async {
                                        int updatedLikes = await toggleLikePost(post['id'], post['likes']);
                                        setState(() {
                                          posts[index]['likes'] = updatedLikes;
                                        });
                                      },
                                    ),
                                    Text("${post['likes']} Likes", style: TextStyle(color: Colors.blue[800])),
                                  ],
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment, color: Colors.green[700]),
                              onPressed: () => _showCommentDialog(context, post['id']),
                            ),
                            IconButton(
                              icon: Icon(Icons.error_outline, color: isReported ? Colors.red : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  if (isReported) {
                                    reportedPosts.remove(post['id']); // Unmark if already reported
                                  } else {
                                    reportedPosts.add(post['id']); // Mark as reported
                                  }
                                });
                              },
                            ),
                          ],
                        ),

                        // Display Comments
                        if (comments.containsKey(post['id']) && comments[post['id']]!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(color: Colors.blue[800]),
                              Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                              ...comments[post['id']]!.map((comment) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text("${comment['userId']}: ${comment['text']}", style: TextStyle(color: Colors.blue[900])),
                                  )),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Future<bool> _hasLikedPost(String postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('liked_$postId') ?? false;
  }

  void _showCommentDialog(BuildContext context, String postId) {
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Comment", style: TextStyle(color: Colors.blue[800])),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(
              labelText: "Comment",
              labelStyle: TextStyle(color: Colors.blue[800]),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue[800]!),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                addComment(postId, commentController.text, context);
                Navigator.pop(context);
              },
              child: Text("Comment", style: TextStyle(color: Colors.green[700])),
            ),
          ],
        );
      },
    );
  }
}