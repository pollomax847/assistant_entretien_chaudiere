import 'package:flutter/material.dart';
import 'rt_chaudiere_form.dart';
import 'rt_pac_form.dart';
import 'rt_clim_form.dart';

enum TypeReleve {
  chaudiere,
  pac,
  clim,
}

class ReleveTechniqueScreen extends StatelessWidget {
  final TypeReleve type;

  const ReleveTechniqueScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Widget form;
    String title;

    switch (type) {
      case TypeReleve.chaudiere:
        form = const RTChaudiereForm();
        title = 'Relevé Technique Chaudière';
        break;
      case TypeReleve.pac:
        form = const RTPACForm();
        title = 'Relevé Technique PAC';
        break;
      case TypeReleve.clim:
        form = const RTClimForm();
        title = 'Relevé Technique Climatisation';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: form,
    );
  }
}