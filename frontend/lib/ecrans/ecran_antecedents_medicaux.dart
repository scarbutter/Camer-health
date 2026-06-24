import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';

class EcranAntecedentsMedicaux extends StatefulWidget {
  const EcranAntecedentsMedicaux({super.key});

  @override
  State<EcranAntecedentsMedicaux> createState() =>
      _EcranAntecedentsMedicauxState();
}

class _EcranAntecedentsMedicauxState extends State<EcranAntecedentsMedicaux> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _maladiesChroniquesController =
      TextEditingController();
  final TextEditingController _medicamentsController = TextEditingController();
  final TextEditingController _antecedentsFamiliauxController =
      TextEditingController();
  final TextEditingController _interventionsChirurgicalesController =
      TextEditingController();
  final TextEditingController _groupeSanguinController =
      TextEditingController();
  bool _fumeur = false;
  bool _alcool = false;
  bool _activitePhysique = false;

  @override
  void dispose() {
    _allergiesController.dispose();
    _maladiesChroniquesController.dispose();
    _medicamentsController.dispose();
    _antecedentsFamiliauxController.dispose();
    _interventionsChirurgicalesController.dispose();
    _groupeSanguinController.dispose();
    super.dispose();
  }

  void _sauvegarderAntecedents() {
    if (!_formKey.currentState!.validate()) return;

    // Ici, on pourrait sauvegarder les données dans une base de données ou un provider
    // Pour l'instant, on affiche juste un message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Antécédents médicaux sauvegardés')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antécédents Médicaux'),
        backgroundColor: ConstantesApp.couleurPrimaire,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Veuillez remplir vos antécédents médicaux',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                // Allergies
                const Text(
                  'Allergies (médicaments, aliments, etc.)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _allergiesController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Pénicilline, arachides...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Maladies chroniques
                const Text(
                  'Maladies chroniques',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _maladiesChroniquesController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Diabète, hypertension...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Médicaments actuels
                const Text(
                  'Médicaments actuels',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _medicamentsController,
                  decoration: const InputDecoration(
                    hintText: 'Liste des médicaments que vous prenez',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Antécédents familiaux
                const Text(
                  'Antécédents familiaux',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _antecedentsFamiliauxController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Cancer, maladies cardiaques...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Interventions chirurgicales
                const Text(
                  'Interventions chirurgicales',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _interventionsChirurgicalesController,
                  decoration: const InputDecoration(
                    hintText: 'Liste des opérations subies',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Groupe sanguin
                const Text(
                  'Groupe sanguin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _groupeSanguinController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: A+, O-, etc.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Habitudes de vie
                const Text(
                  'Habitudes de vie',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Fumeur'),
                  value: _fumeur,
                  onChanged: (value) =>
                      setState(() => _fumeur = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Consommation d\'alcool'),
                  value: _alcool,
                  onChanged: (value) =>
                      setState(() => _alcool = value ?? false),
                ),
                CheckboxListTile(
                  title: const Text('Activité physique régulière'),
                  value: _activitePhysique,
                  onChanged: (value) =>
                      setState(() => _activitePhysique = value ?? false),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _sauvegarderAntecedents,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantesApp.couleurPrimaire,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Sauvegarder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
