import 'package:flutter/material.dart';

/// Écran affichant les conseils de prévention en santé

class EcranPrevention extends StatelessWidget {
  const EcranPrevention({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prévention'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Conseils de Prévention',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              _construireCarteConseil(
                'Port du Masque',
                'Portez un masque dans les lieux publics',
                Icons.masks,
              ),
              _construireCarteConseil(
                'Alimentation Saine',
                'Consommez 5 fruits et légumes par jour',
                Icons.restaurant,
              ),
              _construireCarteConseil(
                'Faire du sport',
                'Pratiquez au moins 30 minutes de sport par jour',
                Icons.fitness_center,
              ),
              _construireCarteConseil(
                'Sommeil Suffisant',
                'Dormez 7 à 8 heures par nuit',
                Icons.bedtime,
              ),
              _construireCarteConseil(
                'Gestion du Stress',
                'Pratiquez la méditation et la relaxation',
                Icons.spa,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireCarteConseil(String titre, String description, IconData icone) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icone, size: 40),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
