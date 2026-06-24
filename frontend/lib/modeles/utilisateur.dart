enum RoleUtilisateur {
  patient,
  medecin,
}

class Utilisateur {
  final String id;
  final String nomUtilisateur;
  final String email;
  final RoleUtilisateur role;
  final String? photoUrl;

  Utilisateur({
    required this.id,
    required this.nomUtilisateur,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': nomUtilisateur,
      'email': email,
      'role': role.name,
      'photoUrl': photoUrl,
    };
  }

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    final patient = json['patient'] as Map<String, dynamic>?;
    final doctor = json['doctor'] as Map<String, dynamic>?;
    final profile = patient ?? doctor;
    final prenom = (profile?['firstName'] as String?) ?? '';
    final nom = (profile?['lastName'] as String?) ?? '';
    final nomComplet = '$prenom $nom'.trim();

    RoleUtilisateur role;
    switch ((json['role'] as String?)?.toUpperCase()) {
      case 'DOCTOR':
        role = RoleUtilisateur.medecin;
        break;
      default:
        role = RoleUtilisateur.patient;
    }

    return Utilisateur(
      id: json['id'] as String,
      nomUtilisateur: nomComplet.isEmpty ? (json['email'] as String) : nomComplet,
      email: json['email'] as String,
      role: role,
      photoUrl: profile?['photoUrl'] as String?,
    );
  }
}
