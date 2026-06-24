import 'package:flutter/material.dart';

/// Fournisseur pour la gestion du thème (mode sombre/clair)

class FournisseurTheme extends ChangeNotifier {
  bool _estModeSombre = false;

  bool get estModeSombre => _estModeSombre;

  /// Bascule entre le mode sombre et le mode clair
  void basculerModeNuit() {
    _estModeSombre = !_estModeSombre;
    notifyListeners();
  }

  /// Définit le mode sombre
  void definirModeSombre(bool estSombre) {
    _estModeSombre = estSombre;
    notifyListeners();
  }

  /// Obtient le thème actuel
  ThemeData obtenirTheme() {
    if (_estModeSombre) {
      return _construireThemeSombre();
    } else {
      return _construireThemeClair();
    }
  }

  /// Construit le thème clair
  ThemeData _construireThemeClair() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A73E8),
        brightness: Brightness.light,
      ),
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Construit le thème sombre
  ThemeData _construireThemeSombre() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1A73E8),
        brightness: Brightness.dark,
      ),
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    );
  }
}
