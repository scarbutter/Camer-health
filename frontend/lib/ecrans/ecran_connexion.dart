import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constantes/constantes_app.dart';
import '../fournisseurs/fournisseur_auth.dart';
import '../fournisseurs/fournisseur_theme.dart';
import '../modeles/utilisateur.dart';

/// Écran de connexion principal avec options de rôle et mode sombre.
class EcranConnexion extends StatefulWidget {
  const EcranConnexion({super.key});

  @override
  State<EcranConnexion> createState() => _EcranConnexionState();
}

class _EcranConnexionState extends State<EcranConnexion> {
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  bool _isLoading = false;
  bool _cacherMotDePasse = true;
  RoleUtilisateur _roleSelectionne = RoleUtilisateur.patient;

  /// Valide les champs et réalise la connexion via le fournisseur d'authentification.
  Future<void> _handleConnexion() async {
    if (_emailController.text.isEmpty || _motDePasseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<FournisseurAuth>(context, listen: false);
    final success = await authProvider.connexion(
      _emailController.text,
      _motDePasseController.text,
      _roleSelectionne,
    );

    setState(() => _isLoading = false);

    if (!success && mounted) {
      final message = authProvider.messageErreur ?? 'Erreur de connexion';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<FournisseurTheme>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/logo.png', height: 80, width: 80),
              const SizedBox(height: 20),
              Text(
                ConstantesApp.nomApp,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ConstantesApp.couleurPrimaire,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    themeProvider.estModeSombre
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  Switch(
                    value: themeProvider.estModeSombre,
                    onChanged: (value) =>
                        themeProvider.definirModeSombre(value),
                  ),
                ],
              ),

              // Sélection du rôle d'utilisateur : patient ou médecin
              Text(
                'Type de compte :',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () => _roleSelectionne = RoleUtilisateur.patient,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _roleSelectionne == RoleUtilisateur.patient
                            ? ConstantesApp.couleurPrimaire
                            : Colors.grey.shade300,
                        foregroundColor:
                            _roleSelectionne == RoleUtilisateur.patient
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text('Patient'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(
                          () => _roleSelectionne = RoleUtilisateur.medecin,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _roleSelectionne == RoleUtilisateur.medecin
                            ? ConstantesApp.couleurPrimaire
                            : Colors.grey.shade300,
                        foregroundColor:
                            _roleSelectionne == RoleUtilisateur.medecin
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text('Médecin'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

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
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail / Nom d\'utilisateur',
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Mot de passe oublié ?'),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleConnexion,
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
                        'Se connecter',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Vous n\'avez pas de compte ?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inscription');
                    },
                    child: const Text('Créer un compte'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Rend un bouton de connexion sociale.
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
        side: BorderSide(color: couleur.withAlpha((0.5 * 255).round())),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }
}
