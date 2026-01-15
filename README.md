# 🎵 Music Finder - Aplicativo de Busca de Músicas

Um aplicativo Flutter que permite buscar e reproduzir prévias de músicas utilizando a API do iTunes/Apple Music.

## 📱 Funcionalidades

- 🔍 **Busca de músicas** por título, artista ou álbum
- 🎧 **Reprodução de prévias** (30 segundos) diretamente no app
- 📊 **Músicas populares** exibidas na tela inicial
- 🖼️ **Capas de álbum** em alta qualidade
- 💰 **Informações de preço** e gênero musical
- ⏱️ **Duração formatada** das músicas
- 🌐 **Suporte a múltiplos gêneros** e moedas

## 🏗️ Arquitetura

O projeto segue uma arquitetura modular com separação de responsabilidades:

### Estrutura de Pastas
```
lib/
├── models/
│   └── music.dart          # Modelo de dados da música
├── services/
│   ├── itunes_service.dart # Integração com API do iTunes
│   └── audio_service.dart  # Gerenciamento de áudio
├── screens/
│   └── home_screen.dart    # Tela principal
├── widgets/
│   ├── music_card.dart     # Card de música
│   └── loading_widget.dart # Indicador de carregamento
└── main.dart              # Ponto de entrada
```

## 📦 Dependências

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0           # Para requisições HTTP
  audioplayers: ^5.3.0   # Para reprodução de áudio
  cached_network_image: ^3.3.0  # Para cache de imagens
```

## 🔧 Configuração

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd music_finder
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Configure a API Key (Opcional)
No arquivo `itunes_service.dart`, você pode configurar uma API Key do RapidAPI se necessário:

```dart
static const String _apiKey = 'sua-api-key-aqui';
```

> **Nota:** A API oficial do iTunes pode funcionar sem chave para uso básico.

### 4. Execute o aplicativo
```bash
flutter run
```

## 🎨 Componentes Principais

### 1. Modelo `Music`
- Representa uma música com todos os dados da API
- Inclui métodos para formatação de tempo, preço e URLs
- Tratamento de valores nulos com defaults apropriados

### 2. `iTunesService`
- Gerencia todas as chamadas à API
- Busca músicas por termo
- Busca músicas populares (atualmente usando "pop" como exemplo)

### 3. `AudioService`
- Gerencia reprodução de áudio com `audioplayers`
- Controle de play/pause/stop
- Mantém estado da música atual

### 4. `HomeScreen`
- Tela principal com barra de busca
- Exibe resultados e músicas populares
- Gerenciamento de estado com `setState`

### 5. `MusicCard`
- Widget reutilizável para exibir informações da música
- Inclui botão de play/pause
- Cache de imagens com `cached_network_image`

## 🔌 API do iTunes

O aplicativo utiliza a [API de busca do iTunes](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html) através de:

- **Endpoint**: `https://itunes.apple.com/search`
- **Parâmetros**: `term`, `media=music`, `entity=song`, `limit=20`
- **Formato de resposta**: JSON

### Exemplo de resposta da API:
```json
{
  "resultCount": 1,
  "results": [{
    "trackName": "Song Name",
    "artistName": "Artist Name",
    "collectionName": "Album Name",
    "artworkUrl100": "https://.../100x100bb.jpg",
    "previewUrl": "https://.../preview.m4a",
    "trackTimeMillis": 240000,
    "primaryGenreName": "Pop",
    "trackPrice": 1.29,
    "currency": "USD",
    "releaseDate": "2023-01-01T08:00:00Z"
  }]
}
```

## 🧪 Testes

Para executar os testes:

```bash
flutter test
```

