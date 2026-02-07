import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/mixins/mixins.dart';

class TirageScreen extends StatefulWidget {
  const TirageScreen({super.key});

  @override
  State<TirageScreen> createState() => _TirageScreenState();
}

class _TirageScreenState extends State<TirageScreen>
    with
        SingleTickerProviderStateMixin,
        AnimationStyleMixin,
        SharedPreferencesMixin,
        SnackBarMixin {
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );
  double _tirage = -0.200; // hPa
  double _co = 150.0; // ppm
  double _o2 = 5.2; // %
  double _co2 = 9.5; // %

  final double _limiteBasse = -0.100;
  final double _idealMin = -0.200;
  final double _idealMax = -0.300;

  static const String _prefKey = 'dernier_tirage';

  @override
  void initState() {
    super.initState();
    _introController.forward();
    _charger();
    _updateSimu(); // init
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    final saved = await loadDouble(_prefKey);
    if (saved != null) {
      setState(() {
        _tirage = saved.clamp(-0.50, -0.05);
        _updateSimu();
      });
    }
  }

  Future<void> _sauvegarder() async {
    await saveDouble(_prefKey, _tirage);
  }

  void _updateSimu() {
    final double tirageAbs = _tirage.abs();
    final double lambda = 0.7 + 2 * tirageAbs;

    if (lambda < 1) {
      _co = 200 + 800 * (1 - lambda);
    } else {
      _co = 50 * exp(-2 * (lambda - 1));
    }
    _co = _co.clamp(50.0, 1200.0);

    _o2 = 2 + 6 * (lambda - 0.8);
    _o2 = _o2.clamp(1.5, 7.5);

    // Calcul CO2 basé sur la combustion (relation inverse avec O2)
    // Pour gaz naturel: CO2 max théorique ≈ 11.7%
    _co2 = 11.7 - (_o2 * 0.5);
    _co2 = _co2.clamp(7.0, 11.0);

    if (_tirage < -0.40) {
      _co *= 0.75;
      _o2 += 0.8;
      _co2 -= 0.5;
    }
  }

  Color get _couleur {
    if (_tirage <= _idealMin && _tirage >= _idealMax) return Colors.green;
    if (_tirage > _limiteBasse && _tirage < _idealMin) return Colors.orange;
    if (_tirage > _limiteBasse) return Colors.red;
    return Colors.blue;
  }

  String get _message {
    if (_couleur == Colors.green) return "Tirage optimal ✅";
    if (_couleur == Colors.orange) return "Tirage limite ⚠️ – surveiller";
    if (_couleur == Colors.red) return "Tirage insuffisant ❌ – danger CO !";
    return "Tirage très fort – vérifier mesure";
  }

  @override
  Widget build(BuildContext context) {
    Widget wrapSection(Widget child, int index) {
      final fade = buildStaggeredFade(_introController, index);
      final slide = buildStaggeredSlide(fade);
      return buildFadeSlide(fade: fade, slide: slide, child: child);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Simulation Tirage Chaudière')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            wrapSection(
              Column(
                children: [
                  Center(
                    child: Text(
                      '${_tirage.toStringAsFixed(3)} hPa',
                      style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: _couleur),
                    ),
                  ),
                  Center(child: Text('Dépression mesurée', style: TextStyle(color: Colors.grey[700]))),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 30,
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[200],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (_tirage.abs() / 0.50).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: _couleur,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('-0.10', style: TextStyle(fontSize: 12)),
                              Text('-0.20', style: TextStyle(fontSize: 12)),
                              Text('-0.30', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              0,
            ),

            const SizedBox(height: 32),

            wrapSection(
              Column(
                children: [
                  Slider(
                    value: -_tirage,
                    min: 0.050,
                    max: 0.500,
                    divisions: 450,
                    label: _tirage.toStringAsFixed(3),
                    activeColor: _couleur,
                    onChanged: (v) {
                      setState(() {
                        _tirage = -(v * 1000).round() / 1000;
                        _updateSimu();
                      });
                      _sauvegarder();
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('-0.05'), Text('-0.50')],
                  ),
                ],
              ),
              1,
            ),

            const SizedBox(height: 32),

            // Graphe des zones de tirage
            wrapSection(
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zones de tirage',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Position du curseur sur l\'échelle :',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Visualisation des zones avec le curseur
                      SizedBox(
                        height: 100,
                        child: CustomPaint(
                          painter: TirageZonePainter(_tirage, _limiteBasse, _idealMin, _idealMax),
                          child: Container(),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      // Légende des zones
                      _buildZoneLegend(Colors.red, 'Zone DANGER', '> -0.10 hPa', 'Tirage insuffisant - Risque CO'),
                      const SizedBox(height: 8),
                      _buildZoneLegend(Colors.orange, 'Zone LIMITE', '-0.10 à -0.20 hPa', 'Acceptable mais à surveiller'),
                      const SizedBox(height: 8),
                      _buildZoneLegend(Colors.green, 'Zone OPTIMALE', '-0.20 à -0.30 hPa', 'Tirage idéal pour combustion'),
                      const SizedBox(height: 8),
                      _buildZoneLegend(Colors.blue, 'Zone FORT', '< -0.30 hPa', 'Tirage très élevé - Vérifier'),
                    ],
                  ),
                ),
              ),
              2,
            ),

            const SizedBox(height: 24),

            wrapSection(
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valeurs mesurées/simulées',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildMeasureRow(
                        'CO',
                        '${_co.toStringAsFixed(0)} ppm',
                        _co > 200 ? Colors.red : Colors.green,
                        _co > 200 ? '⚠️ Élevé' : '✓ OK',
                      ),
                      const Divider(height: 20),
                      _buildMeasureRow(
                        'O₂',
                        '${_o2.toStringAsFixed(1)} %',
                        _o2 < 3 ? Colors.orange : Colors.blue,
                        _o2 < 3 ? '⚠️ Faible' : '✓ Normal',
                      ),
                      const Divider(height: 20),
                      _buildMeasureRow(
                        'CO₂',
                        '${_co2.toStringAsFixed(1)} %',
                        _co2 > 9 ? Colors.green : Colors.orange,
                        _co2 > 9 ? '✓ Bon' : 'ℹ️ Moyen',
                      ),
                    ],
                  ),
                ),
              ),
              3,
            ),

            const SizedBox(height: 24),
            wrapSection(
              Text(
                _message,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _couleur),
                textAlign: TextAlign.center,
              ),
              4,
            ),

            const SizedBox(height: 32),

            wrapSection(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset -0.180'),
                    onPressed: () {
                      setState(() => _tirage = -0.180);
                      _updateSimu();
                      _sauvegarder();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('Exporter'),
                    onPressed: () {
                      final text = 'Tirage: ${_tirage.toStringAsFixed(3)} hPa | CO: ${_co.toStringAsFixed(0)} ppm | O₂: ${_o2.toStringAsFixed(1)} % | CO₂: ${_co2.toStringAsFixed(1)} %';
                      Clipboard.setData(ClipboardData(text: text));
                      showCopied();
                    },
                  ),
                ],
              ),
              5,
            ),

            const SizedBox(height: 40),
            wrapSection(
              const Text(
                'Simulation illustrative – toujours utiliser un vrai analyseur !',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneLegend(Color color, String title, String range, String description) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title ($range)',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeasureRow(String label, String value, Color color, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              status,
              style: TextStyle(fontSize: 14, color: color),
            ),
          ],
        ),
      ],
    );
  }
}

// Painter pour visualiser les zones de tirage
class TirageZonePainter extends CustomPainter {
  final double tirage;
  final double limiteBasse;
  final double idealMin;
  final double idealMax;

  TirageZonePainter(this.tirage, this.limiteBasse, this.idealMin, this.idealMax);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Échelle : de -0.50 (gauche) à -0.05 (droite)
    final minValue = -0.50;
    final maxValue = -0.05;
    final range = maxValue - minValue;

    double getX(double value) {
      return ((value - minValue) / range) * size.width;
    }

    // Zone DANGER (rouge) : > -0.10
    paint.color = Colors.red.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTWH(getX(limiteBasse), 0, size.width - getX(limiteBasse), size.height),
      paint,
    );

    // Zone LIMITE (orange) : -0.10 à -0.20
    paint.color = Colors.orange.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTWH(getX(idealMin), 0, getX(limiteBasse) - getX(idealMin), size.height),
      paint,
    );

    // Zone OPTIMALE (vert) : -0.20 à -0.30
    paint.color = Colors.green.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTWH(getX(idealMax), 0, getX(idealMin) - getX(idealMax), size.height),
      paint,
    );

    // Zone FORT (bleu) : < -0.30
    paint.color = Colors.blue.withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, getX(idealMax), size.height),
      paint,
    );

    // Dessiner les lignes de séparation
    final linePaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(getX(limiteBasse), 0), Offset(getX(limiteBasse), size.height), linePaint);
    canvas.drawLine(Offset(getX(idealMin), 0), Offset(getX(idealMin), size.height), linePaint);
    canvas.drawLine(Offset(getX(idealMax), 0), Offset(getX(idealMax), size.height), linePaint);

    // Dessiner le curseur de position actuelle
    final cursorX = getX(tirage);
    final cursorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Triangle pointant vers le bas
    final path = Path();
    path.moveTo(cursorX, 0);
    path.lineTo(cursorX - 10, -15);
    path.lineTo(cursorX + 10, -15);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.black);

    // Ligne verticale
    canvas.drawLine(Offset(cursorX, 0), Offset(cursorX, size.height), cursorPaint);

    // Labels des valeurs clés
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    void drawLabel(String text, double value, double offsetY) {
      textPainter.text = TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(getX(value) - textPainter.width / 2, size.height + offsetY),
      );
    }

    drawLabel('-0.50', -0.50, 5);
    drawLabel('-0.30', -0.30, 5);
    drawLabel('-0.20', -0.20, 5);
    drawLabel('-0.10', -0.10, 5);
    drawLabel('-0.05', -0.05, 5);
  }

  @override
  bool shouldRepaint(TirageZonePainter oldDelegate) {
    return oldDelegate.tirage != tirage;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
