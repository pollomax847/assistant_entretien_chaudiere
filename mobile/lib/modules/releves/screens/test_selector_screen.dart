import 'package:flutter/material.dart';

class TestSelectorScreen extends StatelessWidget {
  const TestSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST - Relevé Technique'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ÉCRAN TEST FONCTIONNE',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
