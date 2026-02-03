import 'package:flutter/material.dart';
import 'vmc_documentation.dart';
import 'vmc_calculator.dart';

class VMCDocumentationScreen extends StatelessWidget {
  final String? typeVMC;

  const VMCDocumentationScreen({super.key, this.typeVMC});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation VMC'),
      ),
      body: typeVMC != null
          ? _buildSingleTypeDoc(context, typeVMC!)
          : _buildAllTypesDoc(context),
    );
  }

  Widget _buildSingleTypeDoc(BuildContext context, String type) {
    final doc = vmcDocumentation[type];
    final checklist = vmcMaintenanceChecklist[type];

    if (doc == null) {
      return const Center(child: Text('Documentation non disponible'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Documentation principale
          SelectableText(
            doc,
            style: const TextStyle(fontSize: 16.0),
          ),
          
          if (checklist != null && checklist.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            // Checklist de maintenance
            Text(
              'Checklist de maintenance',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              color: Colors.blue.withAlpha(25),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: checklist.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.check_circle_outline, size: 20, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(item),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAllTypesDoc(BuildContext context) {
    final types = VMCCalculator.getTypesVMC();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final value = type['value']!;
        final label = type['label']!;

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: const Icon(Icons.air, color: Colors.blue),
            title: Text(label),
            subtitle: Text(_getShortDescription(value)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VMCDocumentationScreen(typeVMC: value),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getShortDescription(String type) {
    switch (type) {
      case 'simple-flux':
        return 'Système de base avec extraction mécanique';
      case 'hygro-a':
        return 'Bouches d\'extraction hygroréglables';
      case 'hygro-b':
        return 'Entrées et extractions hygroréglables';
      case 'double-flux':
        return 'Récupération de chaleur et filtration';
      case 'vmc-gaz':
        return 'Ventilation et évacuation des fumées';
      default:
        return '';
    }
  }
}
