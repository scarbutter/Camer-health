import 'package:flutter/material.dart';
import '../modeles/specialisation.dart';
import 'ecran_medecins_par_categorie.dart';

/// Écran pour joindre un médecin

class EcranJoindreMedecin extends StatelessWidget {
  const EcranJoindreMedecin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joindre un Médecin'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Choisissez une spécialité',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une spécialité...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Specialisation.specialisationsMock.length,
                itemBuilder: (context, index) {
                  final specialisation = Specialisation.specialisationsMock[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.medical_services),
                      ),
                      title: Text(specialisation.nom),
                      subtitle: Text('${specialisation.nombreMedecins} médecins disponibles'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EcranMedecinsParCategorie(specialisation: specialisation),
                          ),
                        );
                      },
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
