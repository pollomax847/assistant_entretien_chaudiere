import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vmc_theme_provider.dart';
import 'vmc_simple_flux_screen.dart';
import 'vmc_double_flux_screen.dart';
import 'vmc_calculator_screen.dart';

class VmcHomeScreen extends StatefulWidget {
  const VmcHomeScreen({super.key});

  @override
  State<VmcHomeScreen> createState() => _VmcHomeScreenState();
}

class _VmcHomeScreenState extends State<VmcHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _sections = [
    {
      'title': 'VMC Simple Flux',
      'subtitle': 'Documentation technique',
      'screen': const VmcSimpleFluxScreen(),
    },
    {
      'title': 'VMC Double Flux',
      'subtitle': 'Documentation technique',
      'screen': const VmcDoubleFluxScreen(),
    },
    {
      'title': 'Calculateur de débits',
      'subtitle': 'Calcul des débits réglementaires',
      'screen': const VmcCalculatorScreen(),
    },
  ];

  List<Map<String, dynamic>> get _filteredSections {
    if (_searchQuery.isEmpty) {
      return _sections;
    }
    return _sections.where((section) =>
        section['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
        section['subtitle'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mémo Technique VMC'),
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<VmcThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              Provider.of<VmcThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                hintText: 'Tapez pour rechercher...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSections.length,
              itemBuilder: (context, index) {
                final section = _filteredSections[index];
                return ListTile(
                  title: Text(section['title']),
                  subtitle: Text(section['subtitle']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => section['screen']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
