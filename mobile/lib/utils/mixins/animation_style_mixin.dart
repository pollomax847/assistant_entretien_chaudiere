import 'package:flutter/material.dart';

/// Mixin pour centraliser les durées/courbes des animations UI.
mixin AnimationStyleMixin {
  Duration get entranceDuration => const Duration(milliseconds: 900);
  Duration get panelDuration => const Duration(milliseconds: 700);
  Duration get fastDuration => const Duration(milliseconds: 350);
  Duration get waveDuration => const Duration(milliseconds: 450);
  Curve get entranceCurve => Curves.easeOut;
  Curve get waveCurve => Curves.easeInOut;
  double get staggerStep => 0.08;
  double get staggerSpan => 0.4;
  Offset get entranceOffset => const Offset(0, 0.06);

  Interval buildInterval(int index, {double? step, double? span}) {
    final double effectiveStep = step ?? staggerStep;
    final double effectiveSpan = span ?? staggerSpan;
    final double start = (index * effectiveStep).clamp(0.0, 0.6);
    final double end = (start + effectiveSpan).clamp(0.0, 1.0);
    return Interval(start, end, curve: entranceCurve);
  }

  Animation<double> buildStaggeredFade(
    AnimationController controller,
    int index, {
    double? step,
    double? span,
  }) {
    return CurvedAnimation(
      parent: controller,
      curve: buildInterval(index, step: step, span: span),
    );
  }

  Animation<Offset> buildStaggeredSlide(
    Animation<double> parent, {
    Offset? begin,
  }) {
    return Tween<Offset>(
      begin: begin ?? entranceOffset,
      end: Offset.zero,
    ).animate(parent);
  }

  Widget buildFadeSlide({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: child,
      ),
    );
  }
}
