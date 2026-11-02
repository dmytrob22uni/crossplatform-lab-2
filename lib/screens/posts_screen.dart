import 'package:flutter/material.dart';
import 'package:list_proj/data/app_db.dart';
import 'package:list_proj/models/post.dart';
import 'package:list_proj/models/user.dart';
import 'package:list_proj/services/api_service.dart';
import 'package:list_proj/widgets/post_tile.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _db = AppDb.instance;
  final _api = ApiService();

  List<Post> _posts = [];
  Map<int, User> _usersById = {};
  bool _loading = true;
  bool _onlyFavorites = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadFromDb(); // show cached data first
    await _refresh(); // then try to update from the network
  }

  Future<void> _loadFromDb() async {
    final users = await _db.getUsers();
    final posts = await _db.getPosts();
    if (!mounted) return; // screen may be closed while waited for db data
    setState(() {
      _usersById = {for (final u in users) u.id: u};
      _posts = posts;
    });
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final users = await _api.fetchUsers();
      final posts = await _api.fetchPosts();
      await _db.saveUsers(users);
      await _db.savePosts(posts);
      _message = null;
    } catch (e) {
      _message = 'Error occured while interacting with API / database.';
    }
    await _loadFromDb();
    if (!mounted) return; // screen may be closed while performed await(s)
    setState(() => _loading = false);
  }

  Future<void> _toggleFavorite(Post post) async {
    setState(() => post.isFavorite = !post.isFavorite); // update value and UI
    await _db.setFavorite(post.id, post.isFavorite); // save to db
  }

  @override
  Widget build(BuildContext context) {
    final visible = _onlyFavorites
        ? _posts.where((p) => p.isFavorite).toList()
        : _posts;

    return Scaffold(
      appBar: AppBar(
        title: Text('PostIn (${visible.length})'),
        actions: [
          IconButton(
            tooltip: 'Favorites only',
            icon: Icon(
              _onlyFavorites ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            onPressed: () => setState(() => _onlyFavorites = !_onlyFavorites),
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_message != null)
            Container(
              width: double.infinity,
              color: Colors.purpleAccent.shade100,
              padding: const EdgeInsets.all(8),
              child: Text(_message!, textAlign: TextAlign.center),
            ),
          Expanded(
            child: _loading && _posts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final post = visible[index];
                        return PostTile(
                          key: ValueKey(post.id),
                          post: post,
                          author: _usersById[post.userId],
                          onToggleFavorite: () => _toggleFavorite(post),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
