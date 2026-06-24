import 'package:flutter/material.dart';

/// Widget pour le menu latéral de l'application

class MenuLateral extends StatelessWidget {
  final Function(String) onMenuItemSelected;

  const MenuLateral({
    Key? key,
    required this.onMenuItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('accueil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Données Vitales'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('donnees_vitales');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Discussions'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('discussions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Statistiques'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('statistiques');
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Joindre Médecin'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('joindre_medecin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Symptômes'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('symptomes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Prévention'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('prevention');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Mon Compte'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('compte');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Déconnexion'),
            onTap: () {
              Navigator.pop(context);
              onMenuItemSelected('deconnexion');
            },
          ),
        ],
      ),
    );
  }
}
