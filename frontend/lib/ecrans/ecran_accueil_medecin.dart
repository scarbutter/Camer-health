import 'package:camerhealth/widgets/barre_navigation_medecin.dart';
import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';
import '../modeles/patient.dart';
import '../widgets/carte_patient.dart';
import 'ecran_liste_discussions.dart';
import 'ecran_statistiques.dart';
import 'ecran_compte.dart';
import 'ecran_profil_patient.dart';

class EcranAccueilMedecin extends StatefulWidget {
  const EcranAccueilMedecin({super.key});

  @override
  State<EcranAccueilMedecin> createState() => _EcranAccueilMedecinState();
}

class _EcranAccueilMedecinState extends State<EcranAccueilMedecin> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate if needed
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranStatistiques()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranListeDiscussions()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranCompte()),
        );
        break;
    }
  }

  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Mes patients',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Patients enregistrés',
                style: TextStyle(color: ConstantesApp.couleurTexteClair),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: Patient.patientsMock.length,
                itemBuilder: (context, index) {
                  final patient = Patient.patientsMock[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EcranProfilPatient(patient: patient),
                        ),
                      );
                    },
                    child: CartePatient(
                      id: patient.id,
                      nom: patient.nom.split(' ').last,
                      prenom: patient.nom.split(' ').first,
                      age: 30, // Valeur par défaut, à ajuster selon les besoins
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 1:
        return const Center(child: Text('Statistiques'));
      case 2:
        return const Center(child: Text('Discussions'));
      case 3:
        return const Center(child: Text('Compte'));
      default:
        return const Center(child: Text('Accueil'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 40),
        backgroundColor: ConstantesApp.couleurPrimaire,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RecherchePatientDelegate(),
              );
            },
          ),
        ],
      ),

      body: _getBodyWidget(_selectedIndex),
      bottomNavigationBar: BarreNavigationMedecin(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class RecherchePatientDelegate extends SearchDelegate<Patient?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final resultats = Patient.patientsMock
        .where((p) => p.nom.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildListeResultats(resultats);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = Patient.patientsMock
        .where((p) => p.nom.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildListeResultats(suggestions);
  }

  Widget _buildListeResultats(List<Patient> resultats) {
    if (resultats.isEmpty) {
      return const Center(child: Text('Aucun patient trouvé'));
    }

    return ListView.builder(
      itemCount: resultats.length,
      itemBuilder: (context, index) {
        final patient = resultats[index];
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(patient.nom),
          subtitle: Text('ID: ${patient.id}'),
          onTap: () {
            close(context, patient);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EcranProfilPatient(patient: patient),
              ),
            );
          },
        );
      },
    );
  }
}
