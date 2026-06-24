import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modeles/utilisateur.dart';
import '../fournisseurs/fournisseur_auth.dart';
import '../constantes/constantes_app.dart';

class EcranInscription extends StatefulWidget {
  const EcranInscription({super.key});

  @override
  State<EcranInscription> createState() => _EcranInscriptionState();
}

class _EcranInscriptionState extends State<EcranInscription> {
  final _nomUtilisateurController = TextEditingController();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  RoleUtilisateur _roleSelectionne = RoleUtilisateur.patient;
  bool _isLoading = false;
  bool _cacherMotDePasse = true;

  Future<void> _handleInscription() async {
    if (_nomUtilisateurController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _motDePasseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<FournisseurAuth>(context, listen: false);
    final success = await authProvider.inscription(
      _nomUtilisateurController.text,
      _emailController.text,
      _motDePasseController.text,
      _roleSelectionne,
    );

    setState(() => _isLoading = false);

    if (!success && mounted) {
      final message = authProvider.messageErreur ?? 'Erreur lors de l\'inscription';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte'), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBoutonSocial(
                  icon: Icons.facebook,
                  texte: 'Continuer avec Facebook',
                  couleur: const Color(0xFF1877F2),
                ),
                const SizedBox(height: 12),
                _buildBoutonSocial(
                  icon: Icons.email,
                  texte: 'Continuer avec Gmail',
                  couleur: const Color(0xFFEA4335),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OU'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),

                TextField(
                  controller: _nomUtilisateurController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _motDePasseController,
                  obscureText: _cacherMotDePasse,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _cacherMotDePasse
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _cacherMotDePasse = !_cacherMotDePasse);
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Type de profil',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<RoleUtilisateur>(
                        title: const Text('Malade'),
                        value: RoleUtilisateur.patient,
                        groupValue: _roleSelectionne,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _roleSelectionne = value);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<RoleUtilisateur>(
                        title: const Text('Médecin'),
                        value: RoleUtilisateur.medecin,
                        groupValue: _roleSelectionne,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _roleSelectionne = value);
                          }
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _handleInscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstantesApp.couleurPrimaire,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Créer le compte',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Vous avez déjà un compte'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Connexion'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoutonSocial({
    required IconData icon,
    required String texte,
    required Color couleur,
  }) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: couleur),
      label: Text(texte),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: couleur.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _nomUtilisateurController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }
}
