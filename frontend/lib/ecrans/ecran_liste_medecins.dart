import 'package:flutter/material.dart';
import '../modeles/medecin.dart';
import '../widgets/medecin_card.dart';
import 'ecran_detail_medecin.dart';

class EcranListeMedecins extends StatelessWidget {
  const EcranListeMedecins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Médecins disponibles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Implémenter les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implémenter le filtre
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Contactez-les',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implémenter "Voir plus"
                  },
                  child: const Text('Voir plus'),
                ),
              ],
            ),
          ),
          // GridView des médecins
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: Medecin.medecinsMock.length,
              itemBuilder: (context, index) {
                final medecin = Medecin.medecinsMock[index];
                return MedecinCard(
                  medecin: medecin,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EcranDetailMedecin(medecin: medecin),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}