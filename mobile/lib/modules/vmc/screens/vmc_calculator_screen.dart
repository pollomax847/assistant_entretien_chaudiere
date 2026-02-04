import 'package:flutter/material.dart';
import '../data/debits_reglementaires.dart';
import '../widgets/vmc_pdf_generator_widget.dart';

class VmcCalculatorScreen extends StatefulWidget {
  const VmcCalculatorScreen({super.key});

  @override
  _VmcCalculatorScreenState createState() => _VmcCalculatorScreenState();
}

class _VmcCalculatorScreenState extends State<VmcCalculatorScreen> {
  String? selectedVmcType;
  String? selectedHousingType;
  final Map<String, TextEditingController> controllers = {
    'cuisine': TextEditingController(),
    'salle-de-bain': TextEditingController(),
    'wc': TextEditingController(),
    'autre-sdb': TextEditingController(),
  };

  Map<String, int> results = {};
  int totalFlow = 0;
  int minimumFlow = 0;
  bool isCalculated = false;

  void calculate() {
    if (selectedVmcType == null || selectedHousingType == null) return;

    results.clear();
    totalFlow = 0;

    controllers.forEach((roomType, controller) {
      int count = int.tryParse(controller.text) ?? 0;
      int flowPerRoom = debitsReglementaires[selectedVmcType!]![roomType] ?? 0;
      int totalForType = count * flowPerRoom;
      results[roomType] = totalForType;
      totalFlow += totalForType;
    });

    minimumFlow = minimumDebitsParLogement[selectedHousingType!] ?? 0;

    setState(() {
      isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur de débits'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedVmcType,
              decoration: const InputDecoration(labelText: 'Type de VMC'),
              items: ['simple-flux', 'hygro-a', 'hygro-b']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => selectedVmcType = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedHousingType,
              decoration: const InputDecoration(labelText: 'Type de logement'),
              items: ['T1', 'T2', 'T3', 'T4', 'T5+']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => selectedHousingType = value),
            ),
            const SizedBox(height: 16),
            ...controllers.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: entry.value,
                decoration: InputDecoration(labelText: 'Nombre de ${entry.key}'),
                keyboardType: TextInputType.number,
              ),
            )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculate,
              child: const Text('Calculer'),
            ),
            const SizedBox(height: 16),
            if (isCalculated) ...[
              const Text('Résultats:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...results.entries.map((entry) => Text('${entry.key}: ${entry.value} m³/h')),
              Text('Débit total: $totalFlow m³/h'),
              Text('Débit minimum réglementaire: $minimumFlow m³/h'),
              Text(
                totalFlow >= minimumFlow ? 'Conforme' : 'Non conforme',
                style: TextStyle(
                  color: totalFlow >= minimumFlow ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => generateVmcPdf(context, selectedVmcType!, selectedHousingType!, controllers, results, totalFlow, minimumFlow),
                child: const Text('Exporter en PDF'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
