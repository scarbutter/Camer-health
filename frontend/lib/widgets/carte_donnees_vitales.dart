import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';

/// Widget pour afficher les cartes de données vitales réutilisables
class CarteDonneesVitales extends StatelessWidget {
  const CarteDonneesVitales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de section + indicateur "En direct"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Constantes Vitales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantesApp.couleurTexteClair,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF34A853),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'En direct',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF34A853),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // BPM + Pas côte à côte
        Row(
          children: [
            Expanded(child: _buildCarteBPM()),
            const SizedBox(width: 12),
            Expanded(child: _buildCarteNbrePas()),
          ],
        ),
        const SizedBox(height: 12),
        // Température pleine largeur
        _buildCarteTemperature(),
      ],
    );
  }

  Widget _buildCarteBPM() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carteDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconeVitale(Icons.favorite, const Color(0xFFE53935)),
              const SizedBox(width: 6),
              const Text(
                'Nbre BPM',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: ConstantesApp.couleurTexteClair,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '72',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              _badgeStatut('Normal', const Color(0xFF34A853)),
            ],
          ),
          const SizedBox(height: 10),
          // Mini courbe (sparkline statique — sera animée avec les données IoT)
          SizedBox(
            height: 28,
            child: CustomPaint(
              size: const Size(double.infinity, 28),
              painter: _SparklinePainter(color: const Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarteNbrePas() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carteDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconeVitale(Icons.directions_run, const Color(0xFF00ACC1)),
              const SizedBox(width: 6),
              const Text(
                'Pas journaliers',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: ConstantesApp.couleurTexteClair,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '98',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'pas',
                style: TextStyle(
                  fontSize: 16,
                  color: ConstantesApp.couleurTexteClair,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.98,
              backgroundColor: const Color(0xFF00ACC1).withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF00ACC1),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCarteTemperature() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _carteDecoration(),
      child: Row(
        children: [
          _iconeVitale(
            Icons.thermostat,
            const Color(0xFFFB8C00),
            size: 20,
            padding: 8,
          ),
          const SizedBox(width: 14),
          const Text(
            'Température corporelle',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ConstantesApp.couleurTexteClair,
            ),
          ),
          const Spacer(),
          const Text(
            '36.7°C',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static BoxDecoration _carteDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: ConstantesApp.couleurOmbre.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static Widget _iconeVitale(
    IconData icon,
    Color color, {
    double size = 16,
    double padding = 6,
  }) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: size),
    );
  }

  static Widget _badgeStatut(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Sparkline statique (sera remplacée par des données IoT en temps réel) ──

class _SparklinePainter extends CustomPainter {
  final Color color;

  const _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Points représentant un rythme cardiaque typique (statiques pour l'instant)
    const points = [0.5, 0.45, 0.55, 0.2, 0.9, 0.3, 0.6, 0.45, 0.5];
    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
