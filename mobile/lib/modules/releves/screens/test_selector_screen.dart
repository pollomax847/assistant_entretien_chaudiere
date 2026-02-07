import 'package:flutter/material.dart';
import '../../../utils/mixins/mixins.dart';

class TestSelectorScreen extends StatefulWidget {
  const TestSelectorScreen({super.key});

  @override
  State<TestSelectorScreen> createState() => _TestSelectorScreenState();
}

class _TestSelectorScreenState extends State<TestSelectorScreen>
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
      appBar: AppBar(
        title: const Text('TEST - Relevé Technique'),
      ),
      body: buildFadeSlide(
        fade: fade,
        slide: slide,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ÉCRAN TEST FONCTIONNE',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
