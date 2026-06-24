import 'package:flutter/material.dart';
import '../widgets/carte_donnees_vitales.dart';
import '../widgets/carte_donnees_statiques.dart';

/// Écran pour enregistrer et visualiser les données vitales

class EcranDonneesVitales extends StatefulWidget {
  const EcranDonneesVitales({Key? key}) : super(key: key);

  @override
  State<EcranDonneesVitales> createState() => _EcranDonneesVitalesState();
}

class _EcranDonneesVitalesState extends State<EcranDonneesVitales> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vos données de santé',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Afficher les cartes de données vitales
            const CarteDonneesVitales(),
            const SizedBox(height: 24),
            // Afficher les cartes de données statiques
            const CarteDonneesStatiques(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
