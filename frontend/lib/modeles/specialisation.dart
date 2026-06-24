class Specialisation {
  final String id;
  final String nom;
  final int nombreMedecins;

  Specialisation({
    required this.id,
    required this.nom,
    required this.nombreMedecins,
  });

  static List<Specialisation> specialisationsMock = [
    Specialisation(id: '1', nom: 'Dentiste', nombreMedecins: 13),
    Specialisation(id: '2', nom: 'Pneumologue', nombreMedecins: 6),
    Specialisation(id: '3', nom: 'Gastroentérologue', nombreMedecins: 8),
    Specialisation(id: '4', nom: 'Cardiologue', nombreMedecins: 15),
    Specialisation(id: '5', nom: 'Pharmacien', nombreMedecins: 10),
  ];
}
