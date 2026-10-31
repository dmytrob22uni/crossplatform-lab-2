import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:list_proj/models/post.dart';
import 'package:list_proj/models/user.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/users'));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => User.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
