import 'package:flutter/material.dart';
import '../models/music.dart';
import '../services/itunes_service.dart';
import '../services/audio_service.dart';
import '../widgets/music_card.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AudioService _audioService = AudioService();
  
  List<Music> _musics = [];
  List<Music> _topSongs = [];
  bool _isLoading = false;
  bool _isLoadingTop = false;
  String? _error;
  String _currentSearch = '';

  @override
  void initState() {
    super.initState();
    _loadTopSongs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadTopSongs() async {
    setState(() {
      _isLoadingTop = true;
    });

    try {
      final songs = await iTunesService.getTopSongs();
      setState(() {
        _topSongs = songs;
      });
    } catch (e) {
      _showError('Erro ao carregar músicas populares: $e');
    } finally {
      setState(() {
        _isLoadingTop = false;
      });
    }
  }

  Future<void> _searchMusic() async {
    if (_searchController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _currentSearch = _searchController.text;
    });

    try {
      final results = await iTunesService.searchMusic(_searchController.text);
      setState(() {
        _musics = results;
        if (results.isEmpty) {
          _error = 'Nenhuma música encontrada para "${_searchController.text}"';
        }
      });
    } catch (e) {
      _showError('Erro na busca: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    setState(() {
      _error = message;
    });
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _error = null;
        });
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _musics = [];
      _error = null;
      _currentSearch = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Music'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de busca
          _buildSearchBar(),
          
          // Mensagem de erro
          if (_error != null) _buildErrorWidget(),
          
          // Conteúdo
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.purple[50],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar músicas, artistas...',
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.purple),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _searchMusic(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _searchMusic,
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            mini: true,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingWidget(message: 'Buscando músicas...');
    }

    if (_currentSearch.isNotEmpty && _musics.isEmpty && _error == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhuma música encontrada',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // Resultados da busca
        if (_musics.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Resultados para "$_currentSearch"',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),

        if (_musics.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MusicCard(
                  music: _musics[index],
                  audioService: _audioService,
                );
              },
              childCount: _musics.length,
            ),
          ),

        // Músicas populares
        if (_musics.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Músicas Populares',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Descubra as músicas mais populares no momento',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (_musics.isEmpty)
          _isLoadingTop
              ? const SliverToBoxAdapter(
                  child: LoadingWidget(message: 'Carregando...'),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return MusicCard(
                        music: _topSongs[index],
                        audioService: _audioService,
                      );
                    },
                    childCount: _topSongs.length,
                  ),
                ),
      ],
    );
  }
}