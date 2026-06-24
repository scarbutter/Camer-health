import 'package:camerhealth/widgets/barre_navigation_patient.dart';
import 'package:camerhealth/widgets/notification_icon.dart';
import 'package:camerhealth/widgets/carte_donnees_vitales.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constantes/constantes_app.dart';
import '../fournisseurs/fournisseur_auth.dart';
import 'ecran_statistiques.dart';
import 'ecran_prevention.dart';
import 'ecran_donnees_vitales.dart';
import 'ecran_joindre_medecin.dart';
import 'ecran_rapport.dart';
import 'ecran_compte.dart';
import 'ecran_liste_discussions.dart';
import 'ecran_liste_medecins.dart';

class EcranAccueilPatient extends StatefulWidget {
  const EcranAccueilPatient({super.key});

  @override
  State<EcranAccueilPatient> createState() => _EcranAccueilPatientState();
}

class _EcranAccueilPatientState extends State<EcranAccueilPatient> {
  int _selectedIndex = 0;

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return ConstantesApp.nomApp;
      case 1:
        return 'Données Vitales';
      case 2:
        return 'Discussions';
      case 3:
        return 'Compte';
      default:
        return ConstantesApp.nomApp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getPageTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: Image.asset('assets/logo.png', height: 40),
        ),
        actions: [const NotificationIcon()],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _AccueilBody(),
          const EcranDonneesVitales(),
          const EcranListeDiscussions(),
          const EcranCompte(),
        ],
      ),
      bottomNavigationBar: BarreNavigationPatient(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

/// Corps de l'écran d'accueil patient
class _AccueilBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<FournisseurAuth>(context);
    final prenom = authProvider.utilisateurActuel?.nomUtilisateur ?? 'Patient';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(prenom),
            const SizedBox(height: 16),
            _buildCapteurCard(),
            const SizedBox(height: 16),
            const CarteDonneesVitales(),
            const SizedBox(height: 24),
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantesApp.couleurTexteClair,
              ),
            ),
            const SizedBox(height: 12),
            _buildServicesGrid(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(String prenom) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Bonjour, ',
                style: TextStyle(
                  fontSize: 14,
                  color: ConstantesApp.couleurTexteClair,
                ),
              ),
              TextSpan(
                text: prenom,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Carte Capteur IoT ─────────────────────────────────────────────────────

  Widget _buildCapteurCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appareils connectés',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ConstantesApp.couleurTexteClair,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ConstantesApp.couleurPrimaire.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bluetooth,
                  color: ConstantesApp.couleurPrimaire,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google pixel watch 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Connecté et actif',
                      style: TextStyle(
                        color: Color(0xFF34A853),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: ConstantesApp.couleurPrimaire,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      _ServiceItem(
        icon: Icons.assignment,
        label: 'Rapports',
        color: ConstantesApp.couleurPrimaire,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranRapport()),
        ),
      ),
      _ServiceItem(
        icon: Icons.bar_chart,
        label: 'Statistiques',
        color: const Color(0xFFFB8C00),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranStatistiques()),
        ),
      ),
      _ServiceItem(
        icon: Icons.shield,
        label: 'Prévention',
        color: ConstantesApp.couleurSecondaire,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranPrevention()),
        ),
      ),
      _ServiceItem(
        icon: Icons.medical_services,
        label: 'Médecins',
        color: const Color(0xFF00ACC1),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EcranListeMedecins()),
        ),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: services.map(_buildCarteService).toList(),
    );
  }

  Widget _buildCarteService(_ServiceItem service) {
    return Card(
      elevation: 2,
      child: GestureDetector(
        onTap: service.onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, color: service.color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                service.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: service.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Modèle interne pour les services ──────────────────────────────────────

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
