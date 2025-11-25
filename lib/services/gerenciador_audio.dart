import 'package:audioplayers/audioplayers.dart';

class GerenciadorAudio {
  static final GerenciadorAudio _instancia = GerenciadorAudio._interno();
  factory GerenciadorAudio() => _instancia;
  GerenciadorAudio._interno();

  final AudioPlayer _playerEfeitos = AudioPlayer();
  final AudioPlayer _playerMusica = AudioPlayer();

  bool _musicaAtiva = true;
  bool _efeitosAtivos = true;
  double _volumeMusica = 0.7;
  double _volumeEfeitos = 1.0;

  // URLs de áudio (em app real, seriam arquivos locais)
  final String _urlMusicaTema = 'https://example.com/musica-tema.mp3';
  final String _urlAcerto = 'https://example.com/acerto.mp3';
  final String _urlErro = 'https://example.com/erro.mp3';
  final String _urlNivelUp = 'https://example.com/nivel-up.mp3';
  final String _urlClick = 'https://example.com/click.mp3';

  Future<void> inicializar() async {
    // Em app real, carregaria os arquivos de áudio
    // Para demo, vamos usar áudio sintetizado ou ficar sem som
    print('Sistema de áudio inicializado');
  }

  Future<void> playMusicaTema() async {
    if (!_musicaAtiva) return;

    try {
      await _playerMusica.stop();
      // await _playerMusica.play(UrlSource(_urlMusicaTema));
      // _playerMusica.setVolume(_volumeMusica);
      // _playerMusica.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Erro ao tocar música tema: $e');
    }
  }

  Future<void> playEfeitoAcerto() async {
    if (!_efeitosAtivos) return;

    try {
      // await _playerEfeitos.play(UrlSource(_urlAcerto));
      // _playerEfeitos.setVolume(_volumeEfeitos);
    } catch (e) {
      print('Erro ao tocar efeito acerto: $e');
    }
  }

  Future<void> playEfeitoErro() async {
    if (!_efeitosAtivos) return;

    try {
      // await _playerEfeitos.play(UrlSource(_urlErro));
      // _playerEfeitos.setVolume(_volumeEfeitos);
    } catch (e) {
      print('Erro ao tocar efeito erro: $e');
    }
  }

  Future<void> playEfeitoNivelUp() async {
    if (!_efeitosAtivos) return;

    try {
      // await _playerEfeitos.play(UrlSource(_urlNivelUp));
      // _playerEfeitos.setVolume(_volumeEfeitos);
    } catch (e) {
      print('Erro ao tocar efeito nível up: $e');
    }
  }

  Future<void> playEfeitoClick() async {
    if (!_efeitosAtivos) return;

    try {
      // await _playerEfeitos.play(UrlSource(_urlClick));
      // _playerEfeitos.setVolume(_volumeEfeitos * 0.5);
    } catch (e) {
      print('Erro ao tocar efeito click: $e');
    }
  }

  Future<void> stopMusica() async {
    await _playerMusica.stop();
  }

  void setMusicaAtiva(bool ativa) {
    _musicaAtiva = ativa;
    if (!ativa) {
      stopMusica();
    } else {
      playMusicaTema();
    }
  }

  void setEfeitosAtivos(bool ativos) {
    _efeitosAtivos = ativos;
  }

  void setVolumeMusica(double volume) {
    _volumeMusica = volume;
    _playerMusica.setVolume(volume);
  }

  void setVolumeEfeitos(double volume) {
    _volumeEfeitos = volume;
  }

  bool get musicaAtiva => _musicaAtiva;
  bool get efeitosAtivos => _efeitosAtivos;
  double get volumeMusica => _volumeMusica;
  double get volumeEfeitos => _volumeEfeitos;

  void dispose() {
    _playerMusica.dispose();
    _playerEfeitos.dispose();
  }
}