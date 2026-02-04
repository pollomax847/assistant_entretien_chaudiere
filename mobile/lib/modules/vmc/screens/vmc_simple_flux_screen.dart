import 'package:flutter/material.dart';
import '../data/vmc_content.dart';

class VmcSimpleFluxScreen extends StatelessWidget {
  const VmcSimpleFluxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VMC Simple Flux'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Semantics(
          label: 'Documentation technique de la VMC Simple Flux',
          child: SelectableText(
            vmcContent['simple-flux']!,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
