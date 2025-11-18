import 'package:flutter/material.dart';

class ChaudiereScreen extends StatefulWidget {
  const ChaudiereScreen({super.key});

  @override
  State<ChaudiereScreen> createState() => _ChaudiereScreenState();
}

class _ChaudiereScreenState extends State<ChaudiereScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion Chaudière'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Module Chaudière',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gestion et surveillance de la chaudière - En développement',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
