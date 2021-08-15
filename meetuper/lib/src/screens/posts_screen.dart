import 'package:flutter/material.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  void initState () {
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

  @override
  Widget build(BuildContext context) {

    var list = _posts.map((post) {
      print(post);
      return ListTile(
        title: Text(post['title'] ?? '-'),
        subtitle: Text(post['body'] ?? '-'),
      );

    }).toList();

    print(list);

    return Scaffold(
        body: ListView(
          children: list,
        ),
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
