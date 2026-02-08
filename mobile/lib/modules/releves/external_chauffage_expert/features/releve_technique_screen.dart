// screens/releve_technique_screen.dart
import 'package:flutter/material.dart';
import '../models/releve_technique.dart';

class ReleveTechniqueScreen extends StatelessWidget {
  final RTType type;

  const ReleveTechniqueScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relevé technique ${type.name}'),
      ),
      body: const Center(
        child: Text('En construction'),
      ),
    );
  }
}
