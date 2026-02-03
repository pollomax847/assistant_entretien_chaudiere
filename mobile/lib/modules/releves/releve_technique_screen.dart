import 'package:flutter/material.dart';
import 'releve_technique_model.dart';
import 'rt_chaudiere_form.dart';
import 'rt_pac_form.dart';
import 'rt_clim_form.dart';

class ReleveTechniqueScreen extends StatelessWidget {
  final TypeReleve type;

  const ReleveTechniqueScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case TypeReleve.chaudiere:
        return const RTChaudiereForm();
      case TypeReleve.pac:
        return const RTPACForm();
      case TypeReleve.clim:
        return const RTClimForm();
    }
  }
}