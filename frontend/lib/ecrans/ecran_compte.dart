import 'package:camerhealth/ecrans/ecran_modifier_compte.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fournisseurs/fournisseur_auth.dart';
import '../fournisseurs/fournisseur_theme.dart';
import '../constantes/constantes_app.dart';
import 'ecran_antecedents_medicaux.dart';

class EcranCompte extends StatelessWidget {
  const EcranCompte({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FournisseurAuth>(context);
    final utilisateur = authProvider.utilisateurActuel;
    final themeProvider = Provider.of<FournisseurTheme>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: utilisateur?.photoUrl != null
                            ? NetworkImage(utilisateur!.photoUrl!)
                            : null,
                        child: utilisateur?.photoUrl == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: ConstantesApp.couleurPrimaire,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 20),
                            color: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fonctionnalité à venir'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Changer photo',
                    style: TextStyle(
                      color: ConstantesApp.couleurPrimaire,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            _buildElementMenu(
              icone: Icons.person_outline,
              titre: 'Mon Compte',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EcranModifierParametres(),
                  ),
                );
              },
            ),
            // _buildElementMenu(
            //   icone: Icons.notifications_outlined,
            //   titre: 'Notifications',
            //   onTap: () {},
            // ),
            _buildElementMenu(
              icone: Icons.brightness_4,
              titre: 'Mode Sombre',
              onTap: () {
                themeProvider.basculerModeNuit();
              },
              estToggleable: true,
              isActive: themeProvider.estModeSombre,
            ),
            _buildElementMenu(
              icone: Icons.medical_services_outlined,
              titre: 'Modifier mes données médicaux',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EcranAntecedentsMedicaux(),
                  ),
                );
              },
            ),
            _buildElementMenu(
              icone: Icons.help_outline,
              titre: 'Aide',
              onTap: () {},
            ),
            _buildElementMenu(
              icone: Icons.logout,
              titre: 'Déconnexion',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                      'Voulez-vous vraiment vous déconnecter?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          authProvider.deconnexion();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Déconnexion',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              estDestructeur: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElementMenu({
    required IconData icone,
    required String titre,
    required VoidCallback onTap,
    bool estDestructeur = false,
    bool estToggleable = false,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(icone, color: estDestructeur ? Colors.red : null),
      title: Text(
        titre,
        style: TextStyle(color: estDestructeur ? Colors.red : null),
      ),
      trailing: estToggleable
          ? Switch(value: isActive, onChanged: (_) => onTap())
          : const Icon(Icons.chevron_right),
      onTap: estToggleable ? null : onTap,
    );
  }
}
