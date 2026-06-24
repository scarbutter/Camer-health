import 'package:flutter/material.dart';
import '../modeles/specialisation.dart';
import '../modeles/medecin.dart';
import 'ecran_detail_medecin.dart';

/// Écran pour afficher les médecins d'une catégorie donnée

class EcranMedecinsParCategorie extends StatelessWidget {
  final Specialisation specialisation;

  const EcranMedecinsParCategorie({Key? key, required this.specialisation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medecins = Medecin.getMedecinsBySpecialisation(specialisation.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Médecins - ${specialisation.nom}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Médecins ${specialisation.nom}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un médecin...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              if (medecins.isEmpty)
                const Center(
                  child: Text('Aucun médecin disponible pour cette spécialité.'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medecins.length,
                  itemBuilder: (context, index) {
                    final medecin = medecins[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.shade50,
                          backgroundImage: medecin.photoUrl != null
                              ? NetworkImage(medecin.photoUrl!)
                              : null,
                          child: medecin.photoUrl == null
                              ? const Icon(Icons.person, color: Colors.blue)
                              : null,
                        ),
                        title: Text(medecin.nom),
                        subtitle: Text('${specialisation.nom}\n${medecin.adresse}'),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EcranDetailMedecin(medecin: medecin),
                            ),
                          );
                        },
                        trailing: ElevatedButton(
                          onPressed: () {
                            // TODO: Joindre le médecin
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Joindre ${medecin.nom}')),
                            );
                          },
                          child: const Text('Joindre'),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
