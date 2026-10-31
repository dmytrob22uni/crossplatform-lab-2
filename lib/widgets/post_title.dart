import 'package:flutter/material.dart';
import 'package:list_proj/models/post.dart';
import 'package:list_proj/models/user.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.post,
    required this.author,
    required this.onToggleFavorite,
  });

  final Post post;
  final User? author; // possible null, the author might not be loaded yet
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(author?.name[0] ?? '?')),
        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${author?.name ?? 'Unknown'} • ${author?.city ?? '-'}\n${post.body}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: Icon(
            post.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: post.isFavorite ? Colors.purpleAccent : null,
          ),
          onPressed: onToggleFavorite,
        ),
      ),
    );
  }
}
