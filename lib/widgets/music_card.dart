// lib/widgets/music_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/music.dart';
import '../services/audio_service.dart';

class MusicCard extends StatefulWidget {
  final Music music;
  final AudioService audioService;

  const MusicCard({
    super.key,
    required this.music,
    required this.audioService,
  });

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool _isThisPlaying = false;

  @override
  void initState() {
    super.initState();
    // Escutar mudanças no estado de reprodução
    widget.audioService.isPlaying ? () {} : null; // Placeholder para observer
  }

  void _togglePlay() async {
    if (!widget.music.hasPreview) return;

    try {
      if (_isThisPlaying) {
        await widget.audioService.pause();
        setState(() {
          _isThisPlaying = false;
        });
      } else {
        // Para qualquer música tocando atualmente
        if (widget.audioService.isPlaying) {
          await widget.audioService.stop();
        }

        await widget.audioService.playPreview(widget.music.previewUrl);
        setState(() {
          _isThisPlaying = true;
        });

        // Simular observer - em app real use Provider ou Stream
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted && _isThisPlaying) {
            setState(() {
              _isThisPlaying = false;
            });
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao reproduzir: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Capa do álbum
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.music.highQualityArtwork,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.music_note, color: Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Informações da música
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.music.trackName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.music.artistName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.music.collectionName,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        widget.music.formattedTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.music.primaryGenreName,
                          style: TextStyle(
                            color: Colors.purple[700],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.music.formattedPrice,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Botão de play
            if (widget.music.hasPreview)
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isThisPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.purple,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }
}