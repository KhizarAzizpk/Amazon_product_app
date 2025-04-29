// main.dart
import 'package:flutter/material.dart';
import 'Screens/ProductScreen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Categories & Products',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  GiftsScreen(),
    );
  }
}