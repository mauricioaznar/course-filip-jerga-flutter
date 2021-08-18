import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:meetuper/src/models/post.dart';
import 'package:meetuper/src/services/post_api_provider.dart';
import 'package:scoped_model/scoped_model.dart';

class PostModel extends Model {
  List<Post> posts = [];
  final testingState = 'Testing State';
  final PostApiProvider _api = PostApiProvider();

  PostModel()
    {
      print('asdfasdfasd');
    fetchPosts();
  }

  void fetchPosts () async {
    List<Post> _posts = await _api.fetchPosts();
    this.posts.addAll(_posts);

    notifyListeners();
  }

  addPost() {
    final id = faker.randomGenerator.integer(9999);
    final title = faker.food.dish();
    final body = faker.food.cuisine();
    final newPost = Post(title: title, body: body, id: id);
    print(title + body);
    posts.add(newPost);
    notifyListeners();
  }
}