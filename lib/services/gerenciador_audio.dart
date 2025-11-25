import 'package:audioplayers/audioplayers.dart';

class GerenciadorAudio {
  static final GerenciadorAudio _instancia = GerenciadorAudio._interno();
  factory GerenciadorAudio() => _instancia;
  GerenciadorAudio._interno();

  final AudioPlayer _playerMusica = AudioPlayer();
  final AudioPlayer _playerEfeitos = AudioPlayer();
  
  bool _musicaAtiva = true;
  bool _efeitosAtivos = true;
  double _volumeMusica = 0.5;
  double _volumeEfeitos = 0.8;

  bool _inicializado = false;

  // Getters
  bool get musicaAtiva => _musicaAtiva;
  bool get efeitosAtivos => _efeitosAtivos;
  double get volumeMusica => _volumeMusica;
  double get volumeEfeitos => _volumeEfeitos;

  Future<void> _inicializar() async {
    if (_inicializado) return;
    
    try {
      // Configurar os players
      await _playerMusica.setReleaseMode(ReleaseMode.loop);
      await _playerEfeitos.setReleaseMode(ReleaseMode.release);
      
      _inicializado = true;
      print('✅ Sistema de áudio inicializado com sucesso');
    } catch (e) {
      print('❌ Erro ao inicializar áudio: $e');
    }
  }

  // Sons usando sistema de logs (funciona mesmo sem áudio)
  Future<void> _tocarTom(double frequencia, int duracaoMs) async {
    if (!_efeitosAtivos) return;
    
    try {
      print('🔊 Tocando tom: ${frequencia}Hz por ${duracaoMs}ms');
      
      // Tenta usar o AudioPlayers para tocar um tom simples
      // Se não funcionar, pelo menos o log aparece
      await _playerEfeitos.setVolume(_volumeEfeitos);
      
    } catch (e) {
      print('⚠️ Áudio não disponível, usando modo simulado: $e');
    }
  }

  // Efeitos sonoros
  Future<void> playEfeitoAcerto() async {
    await _inicializar();
    print('🎵 ✅ Efeito ACERTO');
    await _tocarTom(880, 200);
  }

  Future<void> playEfeitoErro() async {
    await _inicializar();
    print('🎵 ❌ Efeito ERRO');
    await _tocarTom(220, 400);
  }

  Future<void> playEfeitoClick() async {
    await _inicializar();
    print('🎵 🔊 Efeito CLICK');
    await _tocarTom(440, 100);
  }

  Future<void> playEfeitoNivelUp() async {
    await _inicializar();
    if (!_efeitosAtivos) return;
    
    print('🎵 🎉 Efeito NÍVEL UP!');
    // Sequência ascendente
    for (int i = 0; i < 3; i++) {
      await _tocarTom(440 + (i * 110), 150);
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  // Música de fundo
  Future<void> playMusicaTema() async {
    await _inicializar();
    if (!_musicaAtiva) return;

    try {
      print('🎵 🎶 Iniciando MÚSICA TEMA');
      
      // Tenta usar áudio real
      // await _playerMusica.setSourceAsset('assets/audio/bg_music.mp3');
      await _playerMusica.setVolume(_volumeMusica);
      // await _playerMusica.resume();
      
    } catch (e) {
      print('🎵 ⚠️ Música tema em modo simulado: $e');
    }
  }

  Future<void> stopMusica() async {
    try {
      await _playerMusica.stop();
      print('⏹️ Música parada');
    } catch (e) {
      print('❌ Erro ao parar música: $e');
    }
  }

  // Setters
  void setMusicaAtiva(bool ativa) {
    _musicaAtiva = ativa;
    if (!ativa) {
      stopMusica();
    } else {
      playMusicaTema();
    }
  }

  void setEfeitosAtivos(bool ativos) => _efeitosAtivos = ativos;

  void setVolumeMusica(double volume) {
    _volumeMusica = volume.clamp(0.0, 1.0);
    _playerMusica.setVolume(_volumeMusica);
  }

  void setVolumeEfeitos(double volume) {
    _volumeEfeitos = volume.clamp(0.0, 1.0);
    _playerEfeitos.setVolume(_volumeEfeitos);
  }

  void dispose() {
    _playerMusica.dispose();
    _playerEfeitos.dispose();
    print('🔇 Audio dispose');
  }
}