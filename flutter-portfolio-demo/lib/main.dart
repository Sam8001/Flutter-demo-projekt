import 'package:flutter/material.dart';
import 'package:flutter_portfolio_demo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FH Study Portfolio Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 108, 173, 234)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
