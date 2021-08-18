import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meetuper/src/models/post.dart';

class PostApiProvider {


  static final PostApiProvider _singleton = PostApiProvider._internal();

  factory PostApiProvider() {
    return _singleton;
  }

  PostApiProvider._internal();

  Future<List<Post>> fetchPosts() async {
    var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    final res = await http.get(url);
    final List<dynamic> parsedJson = json.decode(res.body);
    final posts = parsedJson.map((parsedPost) {
      return Post.fromJSON(parsedPost);
    }).take(2).toList();
    return posts;
  }
}