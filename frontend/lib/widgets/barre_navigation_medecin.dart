import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';

class BarreNavigationMedecin extends StatefulWidget {
  const BarreNavigationMedecin({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final void Function(int) onItemTapped;

  @override
  State<BarreNavigationMedecin> createState() => _BarreNavigationMedecinState();
}

class _BarreNavigationMedecinState extends State<BarreNavigationMedecin> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      indicatorColor: ConstantesApp.couleurPrimaire.withOpacity(0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: widget.onItemTapped,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: ConstantesApp.couleurPrimaire),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(
            Icons.bar_chart,
            color: ConstantesApp.couleurPrimaire,
          ),
          label: 'Stats',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(
            Icons.chat_bubble,
            color: ConstantesApp.couleurPrimaire,
          ),
          label: 'Messages',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(
            Icons.person,
            color: ConstantesApp.couleurPrimaire,
          ),
          label: 'Profil',
        ),
      ],
    );
  }
}
