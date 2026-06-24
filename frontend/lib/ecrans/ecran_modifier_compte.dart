import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fournisseurs/fournisseur_auth.dart';
import '../constantes/constantes_app.dart';

class EcranModifierParametres extends StatefulWidget {
  const EcranModifierParametres({super.key});

  @override
  State<EcranModifierParametres> createState() =>
      _EcranModifierParametresState();
}

class _EcranModifierParametresState extends State<EcranModifierParametres> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _ancienMdpController;
  late TextEditingController _nouveauMdpController;
  late TextEditingController _confirmerMdpController;
  bool _estEnChargement = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<FournisseurAuth>(context, listen: false);
    final utilisateur = authProvider.utilisateurActuel;
    _nomController = TextEditingController(
      text: utilisateur?.nomUtilisateur ?? '',
    );
    _emailController = TextEditingController(text: utilisateur?.email ?? '');
    _ancienMdpController = TextEditingController();
    _nouveauMdpController = TextEditingController();
    _confirmerMdpController = TextEditingController();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _ancienMdpController.dispose();
    _nouveauMdpController.dispose();
    _confirmerMdpController.dispose();
    super.dispose();
  }

  Future<void> _sauvegarderProfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _estEnChargement = true);

    final authProvider = Provider.of<FournisseurAuth>(context, listen: false);
    authProvider.mettreAJourProfil(_nomController.text, _emailController.text);

    setState(() => _estEnChargement = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil mis à jour avec succès')),
    );

    Navigator.pop(context);
  }

  Future<void> _changerMotDePasse() async {
    if (_nouveauMdpController.text != _confirmerMdpController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    setState(() => _estEnChargement = true);

    final authProvider = Provider.of<FournisseurAuth>(context, listen: false);
    final success = await authProvider.changerMotDePasse(
      _ancienMdpController.text,
      _nouveauMdpController.text,
    );

    setState(() => _estEnChargement = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe changé avec succès')),
      );
      _ancienMdpController.clear();
      _nouveauMdpController.clear();
      _confirmerMdpController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors du changement de mot de passe'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier les paramètres'),
        backgroundColor: ConstantesApp.couleurPrimaire,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informations du profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom d\'utilisateur';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _estEnChargement ? null : _sauvegarderProfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantesApp.couleurPrimaire,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _estEnChargement
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sauvegarder le profil',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Changer le mot de passe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ancienMdpController,
                  decoration: const InputDecoration(
                    labelText: 'Ancien mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nouveauMdpController,
                  decoration: const InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmerMdpController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmer le nouveau mot de passe',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _nouveauMdpController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _estEnChargement ? null : _changerMotDePasse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantesApp.couleurPrimaire,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _estEnChargement
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Changer le mot de passe',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
