import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import '../../utils/mixins/mixins.dart';

class ChaudiereScreen extends StatefulWidget {
  const ChaudiereScreen({super.key});

  @override
  State<ChaudiereScreen> createState() => _ChaudiereScreenState();
}

class _ChaudiereScreenState extends State<ChaudiereScreen> 
    with
        SingleTickerProviderStateMixin,
        AnimationStyleMixin,
        SharedPreferencesMixin,
        SnackBarMixin {
  late final AnimationController _introController = AnimationController(
    vsync: this,
    duration: entranceDuration,
  );
  double _tirage = -0.180; // hPa
  double _co = 150.0;      // ppm
  double _o2 = 5.2;        // %

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
    // Simulation plus réaliste (courbe exponentielle pour CO quand tirage faible)
    final double tirageAbs = _tirage.abs(); // 0.05 à 0.50

    // CO : base 80-120 ppm, explose exponentiellement quand tirage < -0.12
    _co = 90 + 120 * pow((1 - tirageAbs / 0.30).clamp(0.0, 1.0), 3) * 8;
    _co = _co.clamp(50.0, 1200.0);

    // O₂ : descend doucement puis plus vite en dessous de -0.12
    _o2 = 6.5 - 4.5 * pow((1 - tirageAbs / 0.35).clamp(0.0, 1.0), 2);
    _o2 = _o2.clamp(1.5, 7.5);

    // Bonus : si tirage très fort (> -0.40), un peu plus d'O₂ et moins de CO
    if (_tirage < -0.40) {
      _co *= 0.75;
      _o2 += 0.8;
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

                  // Jauge simple
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

            // Slider ultra-précis
            wrapSection(
              Column(
                children: [
                  Slider(
                    value: _tirage,
                    min: -0.500,
                    max: -0.050,
                    divisions: 450,
                    label: _tirage.toStringAsFixed(3),
                    activeColor: _couleur,
                    onChanged: (v) {
                      setState(() {
                        _tirage = (v * 1000).round() / 1000;
                        _updateSimu();
                      });
                      _sauvegarder();
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('-0.50'), Text('-0.05')],
                  ),
                ],
              ),
              1,
            ),

            const SizedBox(height: 32),

            // Graphique CO / O₂
            wrapSection(
              Column(
                children: [
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minX: -0.50,
                        maxX: -0.05,
                        minY: 0,
                        maxY: 1000,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(2)),
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          // CO (rouge)
                          LineChartBarData(
                            spots: List.generate(20, (i) {
                              double t = -0.50 + i * (0.45 / 19);
                              double co = 90 + 120 * pow((1 - t.abs() / 0.30).clamp(0.0, 1.0), 3) * 8;
                              if (t < -0.40) co *= 0.75;
                              return FlSpot(t, co.clamp(0, 1200));
                            }),
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                          // O₂ (bleu) – échelle secondaire simulée (multipliée par 100 pour visibilité)
                          LineChartBarData(
                            spots: List.generate(20, (i) {
                              double t = -0.50 + i * (0.45 / 19);
                              double o2 = 6.5 - 4.5 * pow((1 - t.abs() / 0.35).clamp(0.0, 1.0), 2);
                              if (t < -0.40) o2 += 0.8;
                              return FlSpot(t, o2 * 100); // ×100 pour voir sur le même graph
                            }),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                String label = spot.barIndex == 0 ? 'CO ≈ ${spot.y.toStringAsFixed(0)} ppm' : 'O₂ ≈ ${(spot.y / 100).toStringAsFixed(1)} %';
                                return LineTooltipItem(label, TextStyle(color: spot.barIndex == 0 ? Colors.red : Colors.blue));
                              }).toList();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LegendItem(color: Colors.red, text: 'CO (ppm)'),
                        SizedBox(width: 24),
                        LegendItem(color: Colors.blue, text: 'O₂ (×100)'),
                      ],
                    ),
                  ),
                ],
              ),
              2,
            ),

            const SizedBox(height: 24),

            // Valeurs actuelles
            wrapSection(
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('CO simulé : ${_co.toStringAsFixed(0)} ppm', style: TextStyle(fontSize: 20, color: _co > 200 ? Colors.red : Colors.green)),
                      const SizedBox(height: 8),
                      Text('O₂ simulé  : ${_o2.toStringAsFixed(1)} %', style: TextStyle(fontSize: 20, color: _o2 < 3 ? Colors.orange : Colors.blue)),
                    ],
                  ),
                ),
              ),
              3,
            ),

            const SizedBox(height: 24),
            wrapSection(
              Text(_message, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _couleur), textAlign: TextAlign.center),
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
                      final text = 'Tirage: ${_tirage.toStringAsFixed(3)} hPa | CO: ${_co.toStringAsFixed(0)} ppm | O₂: ${_o2.toStringAsFixed(1)} %';
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
              const Text('Simulation illustrative – toujours utiliser un vrai analyseur !', style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center),
              6,
            ),
          ],
        ),
      ),
    );
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