import 'package:flutter/material.dart';
import '../modeles/utilisateur.dart';
import '../services/service_api.dart';

class FournisseurAuth extends ChangeNotifier {
  Utilisateur? _utilisateurActuel;
  bool _estConnecte = false;
  RoleUtilisateur _roleUtilisateur = RoleUtilisateur.patient;
  String? _messageErreur;

  Utilisateur? get utilisateurActuel => _utilisateurActuel;
  bool get estConnecte => _estConnecte;
  RoleUtilisateur get roleUtilisateur => _roleUtilisateur;
  String? get messageErreur => _messageErreur;

  Future<bool> connexion(
    String email,
    String motDePasse,
    RoleUtilisateur role,
  ) async {
    _messageErreur = null;
    try {
      final response = await ServiceApi.post('/auth/login', {
        'email': email,
        'password': motDePasse,
      });

      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;

        _utilisateurActuel = Utilisateur.fromJson(userJson);
        _roleUtilisateur = _utilisateurActuel!.role;
        _estConnecte = true;
        ServiceApi.setSession(token, userJson['id'] as String);
        notifyListeners();
        return true;
      }

      _messageErreur =
          response['message'] as String? ?? 'Erreur de connexion';
      notifyListeners();
      return false;
    } catch (e) {
      _messageErreur = 'Erreur réseau. Vérifiez votre connexion.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> inscription(
    String nomUtilisateur,
    String email,
    String motDePasse,
    RoleUtilisateur role,
  ) async {
    _messageErreur = null;
    try {
      final parts = nomUtilisateur.trim().split(' ');
      final firstName = parts.first;
      final lastName =
          parts.length > 1 ? parts.sublist(1).join(' ') : '';

      final path = role == RoleUtilisateur.patient
          ? '/auth/register/patient'
          : '/auth/register/doctor';

      final response = await ServiceApi.post(path, {
        'email': email,
        'password': motDePasse,
        'firstName': firstName,
        'lastName': lastName,
      });

      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;

        if (role == RoleUtilisateur.medecin) {
          _messageErreur = data['message'] as String? ??
              'Compte créé. En attente de validation par un administrateur.';
          notifyListeners();
          return false;
        }

        final token = data['token'] as String;
        final userJson = data['user'] as Map<String, dynamic>;

        _utilisateurActuel = Utilisateur.fromJson(userJson);
        _roleUtilisateur = _utilisateurActuel!.role;
        _estConnecte = true;
        ServiceApi.setSession(token, userJson['id'] as String);
        notifyListeners();
        return true;
      }

      _messageErreur =
          response['message'] as String? ?? 'Erreur d\'inscription';
      notifyListeners();
      return false;
    } catch (e) {
      _messageErreur = 'Erreur réseau. Vérifiez votre connexion.';
      notifyListeners();
      return false;
    }
  }

  void deconnexion() {
    _utilisateurActuel = null;
    _estConnecte = false;
    _messageErreur = null;
    ServiceApi.clearSession();
    notifyListeners();
  }

  void mettreAJourPhoto(String url) {
    if (_utilisateurActuel != null) {
      _utilisateurActuel = Utilisateur(
        id: _utilisateurActuel!.id,
        nomUtilisateur: _utilisateurActuel!.nomUtilisateur,
        email: _utilisateurActuel!.email,
        role: _utilisateurActuel!.role,
        photoUrl: url,
      );
      notifyListeners();
    }
  }

  void mettreAJourProfil(String nomUtilisateur, String email) {
    if (_utilisateurActuel != null) {
      _utilisateurActuel = Utilisateur(
        id: _utilisateurActuel!.id,
        nomUtilisateur: nomUtilisateur,
        email: email,
        role: _utilisateurActuel!.role,
        photoUrl: _utilisateurActuel!.photoUrl,
      );
      notifyListeners();
    }
  }

  Future<bool> changerMotDePasse(
    String ancienMotDePasse,
    String nouveauMotDePasse,
  ) async {
    try {
      final response = await ServiceApi.post('/auth/change-password', {
        'oldPassword': ancienMotDePasse,
        'newPassword': nouveauMotDePasse,
      });
      return response['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
