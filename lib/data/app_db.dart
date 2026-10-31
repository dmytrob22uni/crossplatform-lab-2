import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:list_proj/models/post.dart';
import 'package:list_proj/models/user.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._(); // singleton

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    // ./list_proj/.dart_tool/sqflite_common_ffi/databases/list_proj.db
    final path = join(await getDatabasesPath(), 'list_proj.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // runs on first launch
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            city TEXT NOT NULL
          )''');
        await db.execute('''
          CREATE TABLE posts(
            id INTEGER PRIMARY KEY,
            userId INTEGER NOT NULL,
            title TEXT NOT NULL,
            body TEXT NOT NULL,
            isFavorite INTEGER NOT NULL DEFAULT 0
          )''');
      },
    );
  }

  Future<void> saveUsers(List<User> users) async {
    final db = await database;
    final batch = db.batch(); // batch for faster inserts in one go
    for (final user in users) {
      batch.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> savePosts(List<Post> posts) async {
    final db = await database;
    final batch = db.batch(); // batch for faster inserts in one go
    for (final post in posts) {
      batch.insert(
        'posts',
        post.toMap(),
        // use ignore to prevent favorites to be rewritten by new posts from API calls
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final rows = await db.query('users');
    return rows.map(User.fromMap).toList();
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final rows = await db.query('posts', orderBy: 'id');
    return rows.map(Post.fromMap).toList();
  }

  Future<void> setFavorite(int postId, bool value) async {
    final db = await database;
    await db.update(
      'posts',
      {'isFavorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [postId], // "?" is replaced; prevents SQL injection
    );
  }
}
