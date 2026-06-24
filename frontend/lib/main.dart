import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'fournisseurs/fournisseur_auth.dart';
import 'fournisseurs/fournisseur_chat.dart';
import 'fournisseurs/fournisseur_stats.dart';
import 'fournisseurs/fournisseur_theme.dart';
import 'modeles/utilisateur.dart';
import 'ecrans/ecran_connexion.dart';
import 'ecrans/ecran_accueil_patient.dart';
import 'ecrans/ecran_accueil_medecin.dart';
import 'ecrans/ecran_inscription.dart';
import 'ecrans/ecran_ouverture.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FournisseurAuth()),
        ChangeNotifierProvider(create: (_) => FournisseurChat()),
        ChangeNotifierProvider(create: (_) => FournisseurStats()),
        ChangeNotifierProvider(create: (_) => FournisseurTheme()),
      ],
      child: const CamerHealthApp(),
    ),
  );
}

class CamerHealthApp extends StatelessWidget {
  const CamerHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FournisseurTheme>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'CamerHealth',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.obtenirTheme(),
          darkTheme: themeProvider.obtenirTheme(),
          themeMode: themeProvider.estModeSombre ? ThemeMode.dark : ThemeMode.light,
          home: EcranOuverture(),
          routes: {
            '/connexion': (context) => const EcranConnexion(),
            '/inscription': (context) => const EcranInscription(),
            '/accueil-patient': (context) => const EcranAccueilPatient(),
            '/accueil-medecin': (context) => const EcranAccueilMedecin(),
            '/accueil': (context) => Consumer<FournisseurAuth>(
              builder: (context, authProvider, _) {
                if (authProvider.estConnecte) {
                  if (authProvider.roleUtilisateur == RoleUtilisateur.patient) {
                    return const EcranAccueilPatient();
                  } else {
                    return const EcranAccueilMedecin();
                  }
                }
                return const EcranConnexion();
              },
            ),
          },
        );
      },
    );
  }
}




