import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';

/// Widget pour afficher les cartes de données statiques
class CarteDonneesStatiques extends StatelessWidget {
  const CarteDonneesStatiques({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre de section
        const Text(
          'Données Statiques',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ConstantesApp.couleurTexteClair,
          ),
        ),
        const SizedBox(height: 12),
        // Poids + Taille côte à côte
        Row(
          children: [
            Expanded(child: _buildCartePoids()),
            const SizedBox(width: 12),
            Expanded(child: _buildCarteTaille()),
          ],
        ),
      ],
    );
  }

  Widget _buildCartePoids() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carteDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconeVitale(Icons.monitor_weight, const Color(0xFFAB47BC)),
              const SizedBox(width: 6),
              const Text(
                'Poids',
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
                '72',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'kg',
                style: TextStyle(
                  fontSize: 14,
                  color: ConstantesApp.couleurTexteClair,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarteTaille() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _carteDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconeVitale(Icons.height, const Color(0xFF1976D2)),
              const SizedBox(width: 6),
              const Text(
                'Taille',
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
                '180',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'cm',
                style: TextStyle(
                  fontSize: 14,
                  color: ConstantesApp.couleurTexteClair,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
          color: ConstantesApp.couleurOmbre.withOpacity(0.1),
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
}
