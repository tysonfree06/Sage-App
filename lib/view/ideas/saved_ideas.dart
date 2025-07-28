import 'package:flutter/material.dart';

class SavedIdeasScreen extends StatefulWidget {
  const SavedIdeasScreen({super.key});

  @override
  State<SavedIdeasScreen> createState() => _SavedIdeasScreenState();
}

class _SavedIdeasScreenState extends State<SavedIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Saved Ideas Screen'),
    );
  }
}
