import 'package:flutter/material.dart';

class FournisseurStats extends ChangeNotifier {
  bool _estGlobal = true;
  bool get estGlobal => _estGlobal;

  final Map<String, dynamic> _statsGlobales = {
    'cas': 66666,
    'deces': 666,
    'guerisons': 20405,
    'actifs': 5405,
    'critiques': 907,
    'tauxGuerison': 30.61,
  };

  final Map<String, dynamic> _statsCameroun = {
    'cas': 5567,
    'deces': 923,
    'guerisons': 3366,
    'actifs': 66,
    'critiques': 6,
    'tauxGuerison': 60.40,
  };

  Map<String, dynamic> get statsActuelles {
    return _estGlobal ? _statsGlobales : _statsCameroun;
  }

  String get regionActuelle {
    return _estGlobal ? 'Global' : 'Cameroun';
  }

  void basculerRegion() {
    _estGlobal = !_estGlobal;
    notifyListeners();
  }
}
