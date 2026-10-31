import 'package:flutter/material.dart';
import 'package:list_proj/models/post.dart';
import 'package:list_proj/models/user.dart';
import 'package:list_proj/widgets/post_title.dart';

void main() => runApp(const MyApp());

final sampleUsers = [
  const User(
    id: 1,
    name: 'Anna Kovalenko',
    email: 'anna@example.com',
    city: 'Kyiv',
  ),
  const User(
    id: 2,
    name: 'Oleh Shevchenko',
    email: 'oleh@example.com',
    city: 'Lviv',
  ),
];
final samplePosts = [
  Post(
    id: 1,
    userId: 1,
    title: 'Hello Flutter',
    body: 'My first post about widgets.',
  ),
  Post(
    id: 2,
    userId: 2,
    title: 'Lists are easy',
    body: 'ListView.builder builds rows on demand.',
  ),
  Post(
    id: 3,
    userId: 1,
    title: 'Two models',
    body: 'Post and User are linked by userId.',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final usersById = <int, User>{for (final u in sampleUsers) u.id: u};

    return MaterialApp(
      title: 'PostIn',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: ListView.builder(
          itemCount: samplePosts.length,
          itemBuilder: (context, index) {
            final post = samplePosts[index];
            return PostTile(
              post: post,
              author: usersById[post.userId],
              onToggleFavorite: () {},
            );
          },
        ),
      ),
    );
  }
}
