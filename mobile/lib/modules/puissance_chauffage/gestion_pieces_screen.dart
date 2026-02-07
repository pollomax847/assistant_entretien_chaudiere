import 'package:flutter/material.dart';
import '../../utils/mixins/mixins.dart';

class GestionPiecesScreen extends StatefulWidget {
  const GestionPiecesScreen({super.key});

  @override
  State<GestionPiecesScreen> createState() => _GestionPiecesScreenState();
}

class _GestionPiecesScreenState extends State<GestionPiecesScreen>
    with SingleTickerProviderStateMixin, AnimationStyleMixin {
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );

  @override
  void initState() {
    super.initState();
    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fade = buildStaggeredFade(_introController, 0);
    final slide = buildStaggeredSlide(fade);
    return Scaffold(
      appBar: AppBar(title: const Text('Puissance Chauffage')),
      body: buildFadeSlide(
        fade: fade,
        slide: slide,
        child: const Center(child: Text('Module Puissance Chauffage')),
      ),
    );
  }
}