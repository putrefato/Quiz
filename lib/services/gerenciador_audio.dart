class GerenciadorAudio {
  static final GerenciadorAudio _instancia = GerenciadorAudio._interno();
  factory GerenciadorAudio() => _instancia;
  GerenciadorAudio._interno();

  bool _musicaAtiva = true;
  bool _efeitosAtivos = true;
  double _volumeMusica = 0.7;
  double _volumeEfeitos = 1.0;

  // Getters
  bool get musicaAtiva => _musicaAtiva;
  bool get efeitosAtivos => _efeitosAtivos;
  double get volumeMusica => _volumeMusica;
  double get volumeEfeitos => _volumeEfeitos;

  // Setters
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
    _volumeMusica = volume.clamp(0.0, 1.0);
  }

  void setVolumeEfeitos(double volume) {
    _volumeEfeitos = volume.clamp(0.0, 1.0);
  }

  // Métodos de áudio
  Future<void> playMusicaTema() async {
    if (!_musicaAtiva) return;
    print('🎵 Tocando música tema (volume: $_volumeMusica)');
  }

  Future<void> playEfeitoAcerto() async {
    if (!_efeitosAtivos) return;
    print('✅ Efeito acerto (volume: $_volumeEfeitos)');
  }

  Future<void> playEfeitoErro() async {
    if (!_efeitosAtivos) return;
    print('❌ Efeito erro (volume: $_volumeEfeitos)');
  }

  Future<void> playEfeitoNivelUp() async {
    if (!_efeitosAtivos) return;
    print('🎉 Efeito nível up (volume: $_volumeEfeitos)');
  }

  Future<void> playEfeitoClick() async {
    if (!_efeitosAtivos) return;
    print('🔊 Efeito click (volume: ${_volumeEfeitos * 0.5})');
  }

  Future<void> stopMusica() async {
    print('⏹️ Parando música');
  }

  void dispose() {
    print('🔇 Audio dispose');
  }
}