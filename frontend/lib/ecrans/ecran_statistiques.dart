import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fournisseurs/fournisseur_stats.dart';
import '../constantes/constantes_app.dart';

class EcranStatistiques extends StatelessWidget {
  const EcranStatistiques({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques'), elevation: 0),
      body: Consumer<FournisseurStats>(
        builder: (context, statsProvider, _) {
          final stats = statsProvider.statsActuelles;
          final estGlobal = statsProvider.estGlobal;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBoutonRegion(
                        context,
                        titre: ConstantesApp.statsGlobal,
                        estSelectionne: estGlobal,
                        onTap: () {
                          if (!estGlobal) statsProvider.basculerRegion();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBoutonRegion(
                        context,
                        titre: ConstantesApp.statsCameroun,
                        estSelectionne: !estGlobal,
                        onTap: () {
                          if (estGlobal) statsProvider.basculerRegion();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Aujourd\'hui',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Hier',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              _buildLigneStat('Cas', stats['cas']),
              _buildLigneStat('Morts', stats['deces']),
              _buildLigneStat('Guerison', stats['guerisons']),
              _buildLigneStat('Actifs', stats['actifs']),
              _buildLigneStat('Critiques', stats['critiques']),

              const SizedBox(height: 24),

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ConstantesApp.couleurSecondaire.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      ConstantesApp.tauxGuerison,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${stats['tauxGuerison']}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ConstantesApp.couleurSecondaire,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: stats['tauxGuerison'] / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: ConstantesApp.couleurSecondaire,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBoutonRegion(
    BuildContext context, {
    required String titre,
    required bool estSelectionne,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: estSelectionne
              ? ConstantesApp.couleurPrimaire
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: estSelectionne
                ? ConstantesApp.couleurPrimaire
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          titre,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: estSelectionne
                ? Colors.white
                : ConstantesApp.couleurTexteFonce,
            fontWeight: estSelectionne ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLigneStat(String label, dynamic valeur) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Text(
              valeur.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              '--',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}
