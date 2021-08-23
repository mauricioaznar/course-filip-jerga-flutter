import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:meetuper/src/models/post.dart';
import 'package:meetuper/src/scoped_model/post_model.dart';
import 'package:meetuper/src/services/post_api_provider.dart';
import 'package:meetuper/src/state/app_state.dart';
import 'package:meetuper/src/widget/bottom_navigation.dart';
import 'package:scoped_model/scoped_model.dart';

class PostsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostsScreenState();
  }
}

class PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PostModel>(
      model: PostModel(),
      child: _PostList(),
    );

    // return _InheritedPost(
    //   child: _PostList(),
    //   posts: _posts,
    //   createPost: _addPost,
    // );
  }
}

class _InheritedPost extends InheritedWidget {
  final List<Post> _posts;
  final Function _createPost;

  const _InheritedPost(
      {required Widget child,
      required List<Post> posts,
      required Function createPost})
      : _posts = posts,
        _createPost = createPost,
        super(child: child);

  static _InheritedPost of(BuildContext context) {
    final _InheritedPost? result =
        context.dependOnInheritedWidgetOfExactType<_InheritedPost>();
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class _PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var list = _posts.map((post) {
    //   print(post);
    //   return ListTile(
    //     title: Text(post['title'] ?? '-'),
    //     subtitle: Text(post['body'] ?? '-'),
    //   );
    // }).toList();

    // final testingData = AppStore.of(context).testingData;
    // final _posts = _InheritedPost.of(context)._posts;
    return ScopedModelDescendant<PostModel>(builder: (context, _, model) {
      final posts = model.posts;
      return Scaffold(
          body: ListView.builder(
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) return Divider();

                final index = i ~/ 2;

                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].body),
                );
              },
              itemCount: posts.length * 2),
          floatingActionButton: _PostButton(),
          bottomNavigationBar: BottomNavigation(
            currentIndex: 0,
            onChange: (int i) {},
          ),
          appBar: AppBar(title: Text('Posts')));
    });
  }
}

class _PostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postModel = ScopedModel.of<PostModel>(context, rebuildOnChange: true);

    // final createPost = _InheritedPost.of(context)._createPost;
    return FloatingActionButton(
        onPressed: () {
          postModel.addPost();
          // createPost();
        },
        tooltip: 'Increment Text',
        child: Icon(Icons.add));
  }
}
