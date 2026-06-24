import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import '../fournisseurs/fournisseur_auth.dart';
import '../fournisseurs/fournisseur_chat.dart';
import '../constantes/constantes_app.dart';
import '../modeles/message.dart';

class EcranDetailDiscussion extends StatefulWidget {
  final String discussionId;
  final String? nomContact;

  const EcranDetailDiscussion({
    Key? key,
    required this.discussionId,
    this.nomContact,
  }) : super(key: key);

  @override
  State<EcranDetailDiscussion> createState() => _EcranDetailDiscussionState();
}

class _EcranDetailDiscussionState extends State<EcranDetailDiscussion> {
  final TextEditingController _controllerMessage = TextEditingController();
  final AudioRecorder _enregistreur = AudioRecorder();
  
  bool _estEnTrainDEnregistrer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FournisseurChat>(context, listen: false)
          .chargerMessages(widget.discussionId);
    });
  }

  @override
  void dispose() {
    _controllerMessage.dispose();
    _enregistreur.dispose();
    super.dispose();
  }

  // --- LOGIQUE ENREGISTREMENT ---

  Future<void> _demarrerEnregistrement() async {
    try {
      if (await _enregistreur.hasPermission()) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/vocal_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        const config = RecordConfig();
        await _enregistreur.start(config, path: path);
        
        if (mounted) setState(() => _estEnTrainDEnregistrer = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permission micro refusée")),
          );
        }
      }
    } catch (e) {
      debugPrint("Erreur démarrage enregistrement: $e");
    }
  }

  Future<void> _arreterEnregistrement() async {
    try {
      final path = await _enregistreur.stop();
      setState(() => _estEnTrainDEnregistrer = false);

      if (path != null) {
        _envoyerMedia(TypeMessage.audio, path, "Message vocal");
      }
    } catch (e) {
      debugPrint("Erreur arrêt enregistrement: $e");
    }
  }

  // --- ENVOI ---

  void _envoyerMedia(TypeMessage type, String path, String contenu) {
    Provider.of<FournisseurChat>(context, listen: false).envoyerMessage(
      widget.discussionId,
      contenu,
      type: type,
      urlMedia: path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomContact ?? widget.discussionId),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<FournisseurChat>(
              builder: (context, chatProvider, _) {
                final messages = chatProvider.getMessages(widget.discussionId);
                final monId = Provider.of<FournisseurAuth>(
                  context,
                  listen: false,
                ).utilisateurActuel?.id ?? '';

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final estMoi = message.expediteurId == monId;

                    return _buildMessageBubble(message, estMoi);
                  },
                );
              },
            ),
          ),
          _buildInputZone(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool estMoi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Align(
        alignment: estMoi ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: estMoi 
                ? ConstantesApp.couleurPrimaire 
                : (Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[800] 
                    : Colors.grey[200]),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(estMoi ? 16 : 0),
              bottomRight: Radius.circular(estMoi ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMessageContent(message, estMoi),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  message.tempsRelatif,
                  style: TextStyle(
                    fontSize: 10,
                    color: estMoi ? Colors.white70 : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(Message message, bool estMoi) {
    Color textColor = estMoi ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    switch (message.type) {
      case TypeMessage.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(message.urlMedia!), height: 200, fit: BoxFit.cover, 
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50)),
        );
      case TypeMessage.audio:
        return _BulleAudio(path: message.urlMedia!, color: textColor);
      case TypeMessage.fichier:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file, color: textColor),
            const SizedBox(width: 8),
            Expanded(child: Text(message.contenu, 
              style: TextStyle(color: textColor), overflow: TextOverflow.ellipsis)),
          ],
        );
      default:
        return Text(message.contenu, style: TextStyle(color: textColor));
    }
  }

  Widget _buildInputZone() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controllerMessage,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Message...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _controllerMessage.text.isEmpty
                ? GestureDetector(
                    onLongPress: _demarrerEnregistrement,
                    onLongPressUp: _arreterEnregistrement,
                    child: CircleAvatar(
                      backgroundColor: _estEnTrainDEnregistrer ? Colors.red : ConstantesApp.couleurPrimaire,
                      child: const Icon(Icons.mic, color: Colors.white, size: 20),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: ConstantesApp.couleurPrimaire,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () {
                        if (_controllerMessage.text.trim().isNotEmpty) {
                          Provider.of<FournisseurChat>(context, listen: false).envoyerMessage(
                            widget.discussionId,
                            _controllerMessage.text.trim(),
                          );
                          _controllerMessage.clear();
                          setState(() {});
                        }
                      },
                    ),
                  ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

class _BulleAudio extends StatefulWidget {
  final String path;
  final Color color;

  const _BulleAudio({required this.path, required this.color});

  @override
  State<_BulleAudio> createState() => _BulleAudioState();
}

class _BulleAudioState extends State<_BulleAudio> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onDurationChanged.listen((d) => setState(() => _duration = d));
    _player.onPositionChanged.listen((p) => setState(() => _position = p));
    _player.onPlayerComplete.listen((_) => setState(() => _isPlaying = false));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: widget.color),
          onPressed: () async {
            if (_isPlaying) {
              await _player.pause();
            } else {
              Source source = widget.path.startsWith('http') 
                  ? UrlSource(widget.path) 
                  : DeviceFileSource(widget.path);
              await _player.play(source);
            }
            setState(() => _isPlaying = !_isPlaying);
          },
        ),
        const SizedBox(width: 4),
        Text(
          "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')} / ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}",
          style: TextStyle(color: widget.color, fontSize: 12),
        ),
      ],
    );
  }
}
