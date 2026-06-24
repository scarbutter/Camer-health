import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';

class BarreNavigationPatient extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BarreNavigationPatient({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BarreNavigationPatient> createState() => _BarreNavigationPatientState();
}

class _BarreNavigationPatientState extends State<BarreNavigationPatient> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      indicatorColor: ConstantesApp.couleurPrimaire.withOpacity(0.12),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (index) {
        widget.onItemTapped(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: ConstantesApp.couleurPrimaire),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite, color: Color(0xFFE53935)),
          label: 'Vitales',
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
