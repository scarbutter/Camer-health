import 'specialisation.dart';
import 'package:collection/collection.dart';

class Medecin {
  final String id;
  final String nom;
  final String specialisationId;
  final String? photoUrl;
  final String email;
  final String telephone;
  final String adresse;
  final double note;
  final int experience;
  final String description;

  Medecin({
    required this.id,
    required this.nom,
    required this.specialisationId,
    this.photoUrl,
    required this.email,
    required this.telephone,
    required this.adresse,
    required this.note,
    required this.experience,
    required this.description,
  });

  Specialisation? get specialisation {
    return Specialisation.specialisationsMock
        .where((spec) => spec.id == specialisationId)
        .firstOrNull;
  }

  static List<Medecin> medecinsMock = [
    Medecin(
      id: '1',
      nom: 'Dr. MBETSI',
      specialisationId: '1', // Dentiste
      photoUrl: 'assets/doc1.jpg',
      email: 'lin@gmail.com',
      telephone: '690555555',
      adresse: 'Yaounde Etoudi',
      note: 4.8,
      experience: 12,
      description: 'Médecin dentiste expérimenté avec plus de 10 ans de pratique. Spécialisé en soins dentaires préventifs et restaurateurs.',
    ),
    Medecin(
      id: '2',
      nom: 'Dr. Martin TSAFACK',
      specialisationId: '1', // Dentiste
      photoUrl: 'assets/doc1.jpg',
      email: 'martin@gmail.com',
      telephone: '689553333',
      adresse: 'Bonapriso, Douala',
      note: 4.6,
      experience: 8,
      description: 'Dentiste passionnée par l\'esthétique dentaire. Utilise les dernières technologies pour des sourires parfaits.',
    ),
    Medecin(
      id: '3',
      nom: 'Dr. Adamou Didier',
      specialisationId: '2', // Pneumologue
      photoUrl: 'assets/doc1.jpg',
      email: 'leroy@gmail.com',
      telephone: '690555555',
      adresse: 'Etam Bafia, Yaoundé',
      note: 4.9,
      experience: 15,
      description: 'Spécialiste en pneumologie avec expertise en maladies respiratoires. Ancien chef de service à l\'hôpital universitaire.',
    ),
    Medecin(
      id: '4',
      nom: 'Dr. Imala',
      specialisationId: '3', // Gastroentérologue
      photoUrl: 'assets/doc1.jpg',
      email: 'imala@gmail.com',
      telephone: '629555555',
      adresse: 'Mokolo, Douala',
      note: 4.7,
      experience: 10,
      description: 'Gastroentérologue spécialisé en endoscopie digestive. Membre de la société française de gastroentérologie.',
    ),
    Medecin(
      id: '5',
      nom: 'Dr. MVONGO',
      specialisationId: '4', // Cardiologue
      photoUrl: 'assets/doc1.jpg',
      email: 'medjo@gmail.com',
      telephone: '655533333',
      adresse: 'eseka, Cameroun',
      note: 4.8,
      experience: 18,
      description: 'Cardiologue interventionnel avec plus de 15 ans d\'expérience en angioplastie et stents coronariens.',
    ),
    Medecin(
      id: '6',
      nom: 'Dr. Petit papa',
      specialisationId: '4', // Cardiologue
      photoUrl: 'assets/doc1.jpg',
      email: 'petit@gmail.com',
      telephone: '677532426',
      adresse: 'briquetterie, Douala',
      note: 4.5,
      experience: 9,
      description: 'Cardiologue spécialisé en électrophysiologie. Expert en traitement des arythmies cardiaques.',
    ),
    Medecin(
      id: '7',
      nom: 'Dr. Kamdem',
      specialisationId: '5', // Pharmacien
      photoUrl: 'assets/doc1.jpg',
      email: 'kamdem@gmail.com',
      telephone: '699555555',
      adresse: 'Pharmacie Emia, Yaoundé',
      note: 4.6,
      experience: 11,
      description: 'Pharmacien titulaire avec expertise en pharmacie clinique. Conseils personnalisés pour votre santé.',
    ),
  ];

  static List<Medecin> getMedecinsBySpecialisation(String specialisationId) {
    return medecinsMock.where((med) => med.specialisationId == specialisationId).toList();
  }
}
