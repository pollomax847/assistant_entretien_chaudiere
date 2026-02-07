import 'package:flutter/material.dart';
import '../utils/mixins/mixins.dart';

class ModulesListScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> modules;

  const ModulesListScreen({
    super.key,
    required this.title,
    required this.modules,
  });

  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen>
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
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.modules.length,
        itemBuilder: (context, index) {
          final module = widget.modules[index];
          final fade = buildStaggeredFade(_listController, index);
          final slide = buildStaggeredSlide(fade);
          return buildFadeSlide(
            fade: fade,
            slide: slide,
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (module['color'] as Color).withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    module['icon'] as IconData,
                    color: module['color'] as Color,
                  ),
                ),
                title: Text(
                  module['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: module['subtitle'] != null
                    ? Text(module['subtitle'] as String)
                    : null,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: module['onTap'] as VoidCallback,
              ),
            ),
          );
        },
      ),
    );
  }
}
