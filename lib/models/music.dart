class Music {
  final String trackName;
  final String artistName;
  final String collectionName;
  final String artworkUrl100;
  final String previewUrl;
  final String trackTimeMillis;
  final String primaryGenreName;
  final double trackPrice;
  final String currency;
  final DateTime? releaseDate;

  Music({
    required this.trackName,
    required this.artistName,
    required this.collectionName,
    required this.artworkUrl100,
    required this.previewUrl,
    required this.trackTimeMillis,
    required this.primaryGenreName,
    required this.trackPrice,
    required this.currency,
    this.releaseDate,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      trackName: json['trackName'] ?? 'Sem título',
      artistName: json['artistName'] ?? 'Artista desconhecido',
      collectionName: json['collectionName'] ?? 'Álbum desconhecido',
      artworkUrl100: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      trackTimeMillis: json['trackTimeMillis']?.toString() ?? '0',
      primaryGenreName: json['primaryGenreName'] ?? 'Gênero desconhecido',
      trackPrice: (json['trackPrice'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      releaseDate: json['releaseDate'] != null 
          ? DateTime.parse(json['releaseDate']) 
          : null,
    );
  }

  // Formata o tempo da música
  String get formattedTime {
    if (trackTimeMillis == '0') return '--:--';
    
    try {
      final milliseconds = int.parse(trackTimeMillis);
      final minutes = (milliseconds / 60000).floor();
      final seconds = ((milliseconds % 60000) / 1000).floor();
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }

  // Formata o preço
  String get formattedPrice {
    if (trackPrice == 0.0) return 'Grátis';
    return '${trackPrice.toStringAsFixed(2)} $currency';
  }

  // Verifica se tem preview para tocar
  bool get hasPreview => previewUrl.isNotEmpty;

  // URL da imagem em alta qualidade
  String get highQualityArtwork {
    return artworkUrl100.replaceAll('100x100', '300x300');
  }
}