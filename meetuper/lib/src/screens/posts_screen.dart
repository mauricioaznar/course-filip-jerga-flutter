import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meetuper/src/widget/bottom_navigation.dart';

class PostsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostsScreenState();
  }
}

class PostsScreenState extends State<PostsScreen> {
  int _counter = 0;
  List<dynamic> _posts = [];

  _increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    http.get(url).then((res) {
      final posts = json.decode(res.body);
      setState(() {
        _posts.addAll(posts);
      });
    });
  }

  @overridek
  Widget build(BuildContext context) {
    return Scaffold(
        body: _PostList(posts: _posts),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _increment();
            },
            tooltip: 'Increment Text',
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomNavigation(),
        appBar: AppBar(title: Text('Posts screen')));
  }
}

class _PostList extends StatelessWidget {
  final List<dynamic> _posts;

  _PostList({required List<dynamic> posts}) : _posts = posts {}

  @override
  Widget build(BuildContext context) {
    // var list = _posts.map((post) {
    //   print(post);
    //   return ListTile(
    //     title: Text(post['title'] ?? '-'),
    //     subtitle: Text(post['body'] ?? '-'),
    //   );
    // }).toList();

    return ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          return ListTile(
            title: Text(_posts[i]['title'] ?? '-'),
            subtitle: Text(_posts[i]['body'] ?? '-'),
          );
        },
        itemCount: _posts.length);
  }
}
