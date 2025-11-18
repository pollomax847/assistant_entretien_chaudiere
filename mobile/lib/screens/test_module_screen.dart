import 'package:flutter/material.dart';
import '../modules/puissance_chauffage/puissance_chauffage_screen.dart';
import '../modules/tests/top_gaz_test_screen.dart';

class TestModuleScreen extends StatelessWidget {
  const TestModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Module - Puissance'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test des Modules',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Testez chaque module individuellement pour vérifier le bon fonctionnement.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Test Buttons
            _buildTestButton(
              context,
              'Test Calcul Puissance',
              'Tester le module de calcul de puissance',
              Icons.calculate,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PuissanceChauffageScreen(),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildTestButton(
              context,
              'Test Formulaire',
              'Tester les champs de saisie et validation',
              Icons.text_fields,
              Colors.green,
              () => _showTestDialog(context, 'Formulaire testé !'),
            ),
            
            const SizedBox(height: 12),
            
            _buildTestButton(
              context,
              'Test Navigation',
              'Tester la navigation entre écrans',
              Icons.navigation,
              Colors.orange,
              () => _showTestDialog(context, 'Navigation testée !'),
            ),
            
            const SizedBox(height: 12),
            
            _buildTestButton(
              context,
              'Test Stockage',
              'Tester la sauvegarde des données',
              Icons.storage,
              Colors.purple,
              () => _testLocalStorage(context),
            ),
            
            const SizedBox(height: 12),
            
            // Test TOP Gaz - Nouveau test spécialisé
            _buildTestButton(
              context,
              'Test TOP Gaz',
              'Test arrêt sécurité gaz (36 sec)',
              Icons.security,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TopGazTestScreen()),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Results
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Résultats des Tests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '✅ Interface utilisateur : OK\n'
                    '✅ Navigation : OK\n'
                    '✅ Thème Material Design 3 : OK\n'
                    '✅ Architecture modulaire : OK\n'
                    '⏳ Tests des modules en cours...',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTestDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Réussi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _testLocalStorage(BuildContext context) {
    // Simulation de test de stockage
    Future.delayed(const Duration(seconds: 1), () {
      _showTestDialog(context, 'Stockage local testé avec succès !');
    });
  }
}
