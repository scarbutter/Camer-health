# CamerHealth

Une application Flutter moderne de suivi des patients a distance dans un contexte de pandemie : Cas du covid 19

## 📋 Description

CamerHealth est une application mobile développée par des etudiants de la promo 2027 de cybersecurte de l'ENSPY avec Flutter qui facilite la communication entre patients et professionnels de santé. Elle offre une interface moderne avec support du mode sombre, permettant aux utilisateurs de gérer leurs données de santé, consulter des statistiques, et communiquer avec leur médecin.

## 🆕 Dernières mises à jour

- **v1.1.0** - Avril 2026
  - Ajout de la fonctionnalité "Modifier les paramètres" pour les patients
  - Nouvelle page "Antécédents médicaux" avec formulaire complet
  - Amélioration de la gestion du profil utilisateur

## ✨ Fonctionnalités

### Pour les Patients
- **Connexion/Inscription** : Authentification sécurisée
- **Tableau de bord** : Vue d'ensemble des données de santé
- **Données Vitales** : Suivi des signes vitaux (fréquence cardiaque, température, nombre de pas)
- **Médecins Disponibles** : Consultation de la liste des médecins, détails et paiement
- **Discussions** : Messagerie directe avec les médecins
- **Statistiques** : Graphiques et analyses des données de santé
- **Prévention** : Conseils et rappels de prévention
- **Rapports** : Génération de rapports médicaux
- **Modifier les paramètres** : Modification du profil utilisateur (nom, email, mot de passe)
- **Antécédents médicaux** : Formulaire pour saisir les informations médicales du patient

### Pour les Médecins
- **Gestion des Patients** : Liste et suivi des patients assignés
- **Données Vitales** : Consultation des données des patients
- **Discussions** : Communication avec les patients
- **Statistiques** : Analyses globales des données de santé

### Fonctionnalités Générales
- **Mode Sombre/Clair** : Adaptation automatique des thèmes
- **Interface Responsive** : Optimisée pour mobile
- **Navigation Intuitive** : Menu latéral et navigation par onglets
- **Sécurité** : Gestion sécurisée des données utilisateur

## 🛠️ Technologies Utilisées

- **Flutter** : Framework de développement cross-platform
- **Dart** : Langage de programmation
- **Material Design 3** : Design system moderne

## 📦 Installation

### Prérequis
- Flutter SDK (version 3.0 ou supérieure)
- Dart SDK
- Android Studio ou VS Code avec extensions Flutter
- Un émulateur Android/iOS ou un appareil physique

### Étapes d'installation

1. **Contribuer au projet**
   
   Contactez les membres de la promo

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Vérifier la configuration**
   ```bash
   flutter doctor
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## 🚀 Utilisation

### Démarrage
1. Lancez l'application
2. Créez un compte ou connectez-vous
3. Sélectionnez votre rôle (Patient ou Médecin)
4. Explorez les fonctionnalités selon votre profil

### Navigation
- Utilisez le menu latéral pour accéder aux différentes sections
- Depuis l'accueil patient, accédez aux "Médecins" pour voir la liste disponible
- Le mode sombre peut être activé/désactivé dans les paramètres du compte

## 📁 Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── constantes/
│   └── constantes_app.dart   # Couleurs et constantes globales
├── modeles/                  # Modèles de données
│   ├── utilisateur.dart
│   ├── patient.dart
│   ├── medecin.dart
│   ├── message.dart
│   └── specialisation.dart
├── fournisseurs/             # Providers pour la gestion d'état
│   ├── fournisseur_auth.dart
│   ├── fournisseur_chat.dart
│   ├── fournisseur_stats.dart
│   └── fournisseur_theme.dart
├── ecrans/                   # Interfaces utilisateur
│   ├── ecran_connexion.dart
│   ├── ecran_inscription.dart
│   ├── ecran_accueil_patient.dart
│   ├── ecran_accueil_medecin.dart
│   ├── ecran_liste_medecins.dart
│   ├── ecran_detail_medecin.dart
│   ├── ecran_compte.dart
│   ├── ecran_modifier_parametres.dart
│   ├── ecran_antecedents_medicaux.dart
│   └── ...
└── widgets/                  # Composants réutilisables
    ├── menu_lateral.dart
    ├── carte_patient.dart
    ├── medecin_card.dart
    └── ...
```

## 🧪 Tests

Pour exécuter les tests :
```bash
flutter test
```

## 📱 Déploiement

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```


### Guidelines
- Respectez le style de code Flutter
- Ajoutez des tests pour les nouvelles fonctionnalités
- Mettez à jour la documentation si nécessaire


## 👥 Auteurs

- **Vladimir M.** - *Développeur front End* -
- **Tresor D.** - *Développeur front End* -
- **Farel M** - *Developpeur front End* -
- **Varese A** - *Developpeur front End* -

