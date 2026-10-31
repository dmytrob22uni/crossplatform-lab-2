import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:list_proj/screens/posts_screen.dart';

void main() {
  // sqflite works natively on Android/iOS
  // sqflite needs the FFI version on desktop
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PostIn',
      theme: ThemeData(colorSchemeSeed: Colors.pinkAccent, useMaterial3: true),
      home: const PostsScreen(),
    );
  }
}
