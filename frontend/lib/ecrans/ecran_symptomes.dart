import 'package:flutter/material.dart';

/// Écran pour signaler des symptômes

class EcranSymptomes extends StatefulWidget {
  const EcranSymptomes({Key? key}) : super(key: key);

  @override
  State<EcranSymptomes> createState() => _EcranSympromesState();
}

class _EcranSympromesState extends State<EcranSymptomes> {
  final TextEditingController _controllerDescription = TextEditingController();
  final List<String> _symptomesSelectionnes = [];

  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signaler des Symptômes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sélectionnez vos symptômes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _construireCheckboxSymptome('Mal de tête'),
              _construireCheckboxSymptome('Fièvre'),
              _construireCheckboxSymptome('Toux'),
              _construireCheckboxSymptome('Fatigue'),
              _construireCheckboxSymptome('Nausée'),
              const SizedBox(height: 20),
              const Text(
                'Description additionnelle',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerDescription,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez vos symptômes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Envoyer les symptômes
                  },
                  child: const Text('Envoyer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construireCheckboxSymptome(String symptome) {
    return CheckboxListTile(
      title: Text(symptome),
      value: _symptomesSelectionnes.contains(symptome),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _symptomesSelectionnes.add(symptome);
          } else {
            _symptomesSelectionnes.remove(symptome);
          }
        });
      },
    );
  }
}
