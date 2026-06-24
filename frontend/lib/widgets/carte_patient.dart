import 'package:flutter/material.dart';

/// Widget pour afficher une carte patient

class CartePatient extends StatelessWidget {
  final String id;
  final String nom;
  final String prenom;
  final int age;
  final String? photoUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CartePatient({
    Key? key,
    required this.id,
    required this.nom,
    required this.prenom,
    required this.age,
    this.photoUrl,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: photoUrl != null
                    ? NetworkImage(photoUrl!)
                    : null,
                child: photoUrl == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$prenom $nom',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Âge: $age ans',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
