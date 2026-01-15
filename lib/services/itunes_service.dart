import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music.dart';

class iTunesService {
  
  static const String _apiKey = '90f98a8138eab2685ebdc47ab3e123247jsw86e7b7b0a84';
  static const String _baseUrl = 'https://itunes.apple.com';

  
  static final Map<String, String> _headers = {
    'X-RapidAPI-Key': _apiKey,
    'X-RapidAPI-Host': 'itunes.apple.com', 
  };

  // Buscar músicas
  static Future<List<Music>> searchMusic(String query) async {
    try {
      print('🔍 Buscando por: "$query"');
      
      // URL da API oficial do iTunes via RapidAPI
      final url = '$_baseUrl/search?term=${Uri.encodeComponent(query)}&media=music&entity=song&limit=20';
      print('🌐 URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: _headers,
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📡 Headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        print('✅ Resultados encontrados: ${results.length}');
        
        List<Music> musics = [];
        for (var item in results) {
          try {
            final music = Music.fromJson(item);
            musics.add(music);
          } catch (e) {
            print('⚠️ Erro ao converter item: $e');
          }
        }
        
        print('🎵 Músicas convertidas: ${musics.length}');
        return musics;
      } else {
        print('❌ Erro HTTP: ${response.statusCode}');
        print('❌ Response: ${response.body}');
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Erro geral: $e');
      throw Exception('Erro ao buscar músicas: $e');
    }
  }

  static Future<List<Music>> getTopSongs() async {
    return await searchMusic('pop');
  }
}