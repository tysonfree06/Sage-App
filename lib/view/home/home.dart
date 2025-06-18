import 'package:flutter/material.dart';
import 'package:sage/app/components/status_bar_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const LightStatusBar(
      child: Scaffold(
        body: Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
