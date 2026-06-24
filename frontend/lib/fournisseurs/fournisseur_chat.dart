import 'package:flutter/material.dart';
import '../modeles/message.dart';
import '../services/service_api.dart';

class FournisseurChat extends ChangeNotifier {
  List<Map<String, dynamic>> _conversations = [];
  final Map<String, List<Message>> _messages = {};
  bool _estEnChargement = false;

  bool get estEnChargement => _estEnChargement;

  List<Map<String, dynamic>> getApercusDiscussions() => _conversations;

  List<Message> getMessages(String partnerId) =>
      _messages[partnerId] ?? [];

  int obtenirNombreMessagesNonLus() {
    int total = 0;
    for (final msgs in _messages.values) {
      total += msgs.where((m) => !m.estLu).length;
    }
    return total;
  }

  Future<void> chargerConversations() async {
    _estEnChargement = true;
    notifyListeners();
    try {
      final res = await ServiceApi.get('/messages');
      if (res['success'] != true) return;

      final currentUserId = ServiceApi.userId;
      final items = (res['data'] as List<dynamic>?) ?? [];

      _conversations = items.map((item) {
        final senderId = item['senderId'] as String;
        final isMe = senderId == currentUserId;
        final partner = (isMe ? item['receiver'] : item['sender'])
            as Map<String, dynamic>;

        final patient = partner['patient'] as Map<String, dynamic>?;
        final doctor = partner['doctor'] as Map<String, dynamic>?;
        final profile = patient ?? doctor;
        final prenom = (profile?['firstName'] as String?) ?? '';
        final nom = (profile?['lastName'] as String?) ?? '';
        final nomComplet = '$prenom $nom'.trim();

        return {
          'id': partner['id'] as String,
          'nom': nomComplet.isEmpty ? (partner['email'] as String) : nomComplet,
          'dernierMessage': (item['content'] as String?) ?? '',
          'heure': _tempsRelatif(item['createdAt'] as String),
          'estEnLigne': false,
        };
      }).toList();
    } catch (_) {
    } finally {
      _estEnChargement = false;
      notifyListeners();
    }
  }

  Future<void> chargerMessages(String partnerId) async {
    try {
      final res = await ServiceApi.get('/messages/$partnerId');
      if (res['success'] != true) return;

      final data = res['data'] as Map<String, dynamic>;
      final items = (data['messages'] as List<dynamic>?) ?? [];

      _messages[partnerId] = items
          .map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (_) {}
  }

  Future<void> envoyerMessage(
    String partnerId,
    String contenu, {
    bool estDeMedecin = true,
    TypeMessage type = TypeMessage.texte,
    String? urlMedia,
  }) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expediteurId: ServiceApi.userId ?? 'moi',
      destinataireId: partnerId,
      contenu: contenu,
      horodatage: DateTime.now(),
      estLu: false,
      type: type,
      urlMedia: urlMedia,
    );

    _messages[partnerId] ??= [];
    _messages[partnerId]!.add(message);
    notifyListeners();

    try {
      await ServiceApi.post('/messages/$partnerId', {
        'content': contenu,
        'type': _typeVersChaine(type),
      });
    } catch (_) {
      _messages[partnerId]?.removeLast();
      notifyListeners();
    }
  }

  String _typeVersChaine(TypeMessage type) {
    switch (type) {
      case TypeMessage.image:
        return 'IMAGE';
      case TypeMessage.audio:
        return 'AUDIO';
      case TypeMessage.fichier:
        return 'FILE';
      default:
        return 'TEXT';
    }
  }

  String _tempsRelatif(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}j';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}min';
      return 'maintenant';
    } catch (_) {
      return '';
    }
  }
}
