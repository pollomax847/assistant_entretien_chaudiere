import 'package:flutter/material.dart';
import '../data/vmc_content.dart';

class VmcDoubleFluxScreen extends StatelessWidget {
  const VmcDoubleFluxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VMC Double Flux'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Semantics(
          label: 'Documentation technique de la VMC Double Flux',
          child: SelectableText(
            vmcContent['double-flux']!,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
