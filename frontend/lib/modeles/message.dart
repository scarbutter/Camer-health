enum TypeMessage { texte, image, audio, fichier }

class Message {
  final String id;
  final String expediteurId;
  final String destinataireId;
  final String contenu;
  final DateTime horodatage;
  final bool estLu;
  final TypeMessage type;
  final String? urlMedia;

  Message({
    required this.id,
    required this.expediteurId,
    required this.destinataireId,
    required this.contenu,
    required this.horodatage,
    this.estLu = false,
    this.type = TypeMessage.texte,
    this.urlMedia,
  });

  String get tempsRelatif {
    final maintenant = DateTime.now();
    final difference = maintenant.difference(horodatage);
    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'maintenant';
    }
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    TypeMessage type;
    switch ((json['type'] as String?)?.toUpperCase()) {
      case 'IMAGE':
        type = TypeMessage.image;
        break;
      case 'AUDIO':
        type = TypeMessage.audio;
        break;
      case 'FILE':
        type = TypeMessage.fichier;
        break;
      default:
        type = TypeMessage.texte;
    }

    return Message(
      id: json['id'] as String,
      expediteurId: json['senderId'] as String,
      destinataireId: json['receiverId'] as String,
      contenu: (json['content'] as String?) ?? '',
      horodatage: DateTime.parse(json['createdAt'] as String),
      estLu: (json['isRead'] as bool?) ?? false,
      type: type,
      urlMedia: json['mediaUrl'] as String?,
    );
  }
}
