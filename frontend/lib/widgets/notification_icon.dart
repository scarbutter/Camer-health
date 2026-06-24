import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fournisseurs/fournisseur_chat.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FournisseurChat>(
      builder: (context, chatProvider, _) {
        final nombreNonLus = chatProvider.obtenirNombreMessagesNonLus();
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 24,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
            if (nombreNonLus > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEA4335),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      nombreNonLus > 99 ? '99+' : nombreNonLus.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
