import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ConstantesApp {
  static const Color couleurPrimaire = Color(0xFF1A73E8);
  static const Color couleurSecondaire = Color(0xFF34A853);
  static const Color couleurErreur = Color(0xFFEA4335);
  static const Color couleurAlerte = Color(0xFFFBBC05);
  static const Color couleurFond = Color(0xFFF5F5F5);
  static const Color couleurTexteFonce = Color(0xFF202124);
  static const Color couleurTexteClair = Color(0xFF5F6368);
  static const Color couleurOmbre = Color(0xFF000000);

  // Web/Desktop → localhost | Android emulator → 10.0.2.2
  static String get urlApi =>
      kIsWeb ? 'http://localhost:3000/api' : 'http://10.0.2.2:3000/api';

  static const String nomApp = 'CamerHealth';
  static const String messageBienvenue = 'Bienvenue !';
  static const String salutation =
      'Salut, De quoi avez vous besoin aujourd\'hui ?';

  static const String statsGlobal = 'Global';
  static const String statsCameroun = 'Cameroun';
  static const String totalCas = 'Cas';
  static const String totalDeces = 'Morts';
  static const String totalGuerisons = 'Guerison';
  static const String totalActifs = 'Actifs';
  static const String totalCritiques = 'Critiques';
  static const String tauxGuerison = 'Taux de guérison';
}
