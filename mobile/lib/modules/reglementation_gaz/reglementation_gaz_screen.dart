import 'package:flutter/material.dart';
import 'dynamic_reglementation_form.dart';

class ReglementationGazScreen extends StatelessWidget {
  const ReglementationGazScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réglementation Gaz'),
            SizedBox(height: 2),
            Text('Réf. réglementation 23/02/2018', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: const DynamicReglementationForm(),
    );
  }
}
