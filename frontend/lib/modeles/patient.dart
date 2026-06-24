class Patient {
  final String id;
  final String nom;
  final String statut;
  final DateTime derniereMiseAJour;
  final String dateDernierEntretien;
  final int frequenceCardiaque;
  final int nombrePas;
  final double temperature;
  final String appareilConnecte;

  Patient({
    required this.id,
    required this.nom,
    required this.statut,
    required this.derniereMiseAJour,
    required this.dateDernierEntretien,
    this.frequenceCardiaque = 90,
    this.nombrePas = 50,
    this.temperature = 37.0,
    this.appareilConnecte = "GOOGLE PIXEL WATCH 1",
  });

  static List<Patient> patientsMock = [
    Patient(
      id: '1',
      nom: 'Monkey D Luffy',
      statut: 'Cas contact',
      derniereMiseAJour: DateTime(2026, 3, 25),
      dateDernierEntretien: '27 Mars 2026',
      frequenceCardiaque: 88,
      nombrePas: 30,
      temperature: 36.8,
    ),
    Patient(
      id: '2',
      nom: 'Mahachev',
      statut: 'Cas contact',
      derniereMiseAJour: DateTime(2026, 3, 25),
      dateDernierEntretien: '27 Mars 2026',
      frequenceCardiaque: 92,
      nombrePas: 45,
      temperature: 37.2,
    ),
    Patient(
      id: '3',
      nom: 'Doumbe Cedric',
      statut: 'Cas critique',
      derniereMiseAJour: DateTime(2026, 3, 25),
      dateDernierEntretien: '27 Mars 2026',
      frequenceCardiaque: 105,
      nombrePas: 20,
      temperature: 38.5,
    ),
  ];
}
