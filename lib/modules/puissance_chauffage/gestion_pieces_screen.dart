import 'package:flutter/material.dart';

class GestionPiecesScreen extends StatefulWidget {
  const GestionPiecesScreen({super.key});

  @override
  State<GestionPiecesScreen> createState() => _GestionPiecesScreenState();
}

class _GestionPiecesScreenState extends State<GestionPiecesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puissance Chauffage')),
      body: const Center(child: Text('Module Puissance Chauffage')),
    );
  }
}