import 'package:flutter/material.dart';
import '../type_releve.dart';
import '../releve_technique_screen_complet.dart';

class ReleveTechniqueSelectorScreen extends StatelessWidget {
  const ReleveTechniqueSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            title: 'Chaudière',
            subtitle: 'Relevé technique chaudière',
            icon: Icons.fireplace,
            color: Colors.orange,
            type: TypeReleve.chaudiere,
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: 'PAC',
            subtitle: 'Relevé technique pompe à chaleur',
            icon: Icons.ac_unit,
            color: Colors.blue,
            type: TypeReleve.pac,
          ),
          const SizedBox(height: 12),
          _buildCard(
            context,
            title: 'Climatisation',
            subtitle: 'Relevé technique climatisation',
            icon: Icons.cloud,
            color: Colors.cyan,
            type: TypeReleve.clim,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required TypeReleve type,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReleveTechniqueScreenComplet(type: type),
          ),
        ),
      ),
    );
  }
}
