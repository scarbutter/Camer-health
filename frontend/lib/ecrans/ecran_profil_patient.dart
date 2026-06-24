import 'package:flutter/material.dart';
import '../constantes/constantes_app.dart';
import '../modeles/patient.dart';

class EcranProfilPatient extends StatelessWidget {
  final Patient patient;

  const EcranProfilPatient({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final estSombre = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profil du Patient'),
        backgroundColor: estSombre ? theme.appBarTheme.backgroundColor : ConstantesApp.couleurPrimaire,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec image et nom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: estSombre ? theme.appBarTheme.backgroundColor : ConstantesApp.couleurPrimaire,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: const DecorationImage(
                        image: NetworkImage("https://placehold.co/120x120/1A73E8/FFFFFF?text=Patient"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    patient.nom,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Patient #${patient.id}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Constantes Vitales
                  Text(
                    'Constantes Vitales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildVitalCard(context, Icons.favorite, '${patient.frequenceCardiaque}', 'BPM', Colors.red),
                      _buildVitalCard(context, Icons.directions_run, '${patient.nombrePas}', 'Pas', Colors.cyan),
                      _buildVitalCard(context, Icons.thermostat, '${patient.temperature}', '°C', Colors.orange),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Section Informations de base
                  Text(
                    'Informations de base',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: estSombre ? [] : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(context, Icons.bloodtype, 'Groupe Sanguin', 'B positif', Colors.red),
                        const Divider(height: 24),
                        _buildInfoRow(context, Icons.warning, 'Allergies', 'Pénicilline, Arachides', Colors.orange),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildInfoRow(context, Icons.person, 'Genre', 'Homme', Colors.blue)),
                            const VerticalDivider(),
                            Expanded(child: _buildInfoRow(context, Icons.calendar_today, 'Âge', '24 ans', Colors.green)),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildInfoRow(context, Icons.height, 'Taille', '1m75', Colors.purple)),
                            const VerticalDivider(),
                            Expanded(child: _buildInfoRow(context, Icons.monitor_weight, 'Poids', '70 Kg', Colors.brown)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalCard(BuildContext context, IconData icon, String value, String unit, Color color) {
    final theme = Theme.of(context);
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.dark ? [] : [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, Color iconColor) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
