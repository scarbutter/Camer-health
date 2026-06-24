import 'package:flutter/material.dart';

/// Écran affichant les rapports de santé

class EcranRapport extends StatelessWidget {
  const EcranRapport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mes Rapports de Santé',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.description),
                      title: Text('Rapport du ${DateTime.now().day}/${DateTime.now().month}'),
                      subtitle: const Text('Dernière mise à jour: aujourd\'hui'),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          // TODO: Télécharger le rapport
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Générer un nouveau rapport
                  },
                  child: const Text('Générer un Nouveau Rapport'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
