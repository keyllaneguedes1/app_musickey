import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingUrl;
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;
  String? get currentPlayingUrl => _currentPlayingUrl;

  // Tocar/preview da música
  Future<void> playPreview(String previewUrl) async {
    try {
      if (_currentPlayingUrl == previewUrl && _isPlaying) {
        await pause();
        return;
      }

      if (_currentPlayingUrl != previewUrl) {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(previewUrl));
        _currentPlayingUrl = previewUrl;
        _isPlaying = true;
      } else {
        await _audioPlayer.resume();
        _isPlaying = true;
      }
    } catch (e) {
      throw Exception('Erro ao tocar música: $e');
    }
  }

  // Pausar
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  // Parar
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentPlayingUrl = null;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}