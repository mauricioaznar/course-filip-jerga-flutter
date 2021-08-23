// ------- THREAD -----------

import 'package:meetuper/src/models/post.dart';
import 'package:meetuper/src/models/user.dart';

class Thread {
  final String title;
  final User user;
  final String updatedAt;
  final List<Post> posts;

  Thread.fromJSON(Map<String, dynamic> parsedJson)
      : this.title = parsedJson['title'],
        this.user = User.fromJSON(parsedJson['user']),
        this.updatedAt = parsedJson['updatedAt'],
        this.posts = parsedJson['posts']
                .map<Post>((json) => Post.fromJSON(json))
                .toList() ??
            [];
}

// ------- POST -----------

// ------- FETCH THREADS -----------

// Future<List<Thread>> fetchThreads(String meetupId) async {
//     final res = await http.get('$url/threads?meetupId=$meetupId');
//     final Map<String, dynamic> parsedBody = json.decode(res.body);
//     List<dynamic> parsedThreads = parsedBody['threads'];
//     return parsedThreads.map((val) => Thread.fromJSON(val)).toList();
//   }
