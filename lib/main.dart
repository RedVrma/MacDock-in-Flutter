import 'package:flutter/material.dart';
import 'package:macdockflutter/widgets/MacDock.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget for the Mac-style Dock.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mac Dock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MacDock(),
    );
  }
}
