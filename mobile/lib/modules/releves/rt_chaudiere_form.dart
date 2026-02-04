import 'package:flutter/material.dart';

class RTChaudiereForm extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDataChanged;

  const RTChaudiereForm({super.key, this.onDataChanged});

  @override
  State<RTChaudiereForm> createState() => _RTChaudiereFormState();
}

class _RTChaudiereFormState extends State<RTChaudiereForm> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Formulaire Chaudière'));
  }
}