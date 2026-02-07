import 'package:flutter/material.dart';
import '../../../utils/mixins/mixins.dart';
import '../type_releve.dart';
import '../releve_technique_screen_complet.dart';

class ReleveTechniqueSelectorScreen extends StatefulWidget {
  const ReleveTechniqueSelectorScreen({super.key});

  @override
  State<ReleveTechniqueSelectorScreen> createState() => _ReleveTechniqueSelectorScreenState();
}

class _ReleveTechniqueSelectorScreenState extends State<ReleveTechniqueSelectorScreen>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late final AnimationController _listController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  @override
  void initState() {
    super.initState();
    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relevé Technique'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAnimatedCard(
            context,
            index: 0,
            title: 'Chaudière',
            subtitle: 'Relevé technique chaudière',
            icon: Icons.fireplace,
            color: Colors.orange,
            type: TypeReleve.chaudiere,
          ),
          const SizedBox(height: 12),
          _buildAnimatedCard(
            context,
            index: 1,
            title: 'PAC',
            subtitle: 'Relevé technique pompe à chaleur',
            icon: Icons.ac_unit,
            color: Colors.blue,
            type: TypeReleve.pac,
          ),
          const SizedBox(height: 12),
          _buildAnimatedCard(
            context,
            index: 2,
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

  Widget _buildAnimatedCard(
    BuildContext context, {
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required TypeReleve type,
  }) {
    final fade = buildStaggeredFade(_listController, index);
    final slide = buildStaggeredSlide(fade);
    return buildFadeSlide(
      fade: fade,
      slide: slide,
      child: _buildCard(
        context,
        title: title,
        subtitle: subtitle,
        icon: icon,
        color: color,
        type: type,
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
            color: color.withValues(alpha: 0.12),
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
