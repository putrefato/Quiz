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
  void setMusicaAtiva(bool ativa) => _musicaAtiva = ativa;
  void setEfeitosAtivos(bool ativos) => _efeitosAtivos = ativos;
  void setVolumeMusica(double volume) => _volumeMusica = volume;
  void setVolumeEfeitos(double volume) => _volumeEfeitos = volume;

  // Métodos vazios por enquanto
  Future<void> playMusicaTema() async {}
  Future<void> playEfeitoAcerto() async {}
  Future<void> playEfeitoErro() async {}
  Future<void> playEfeitoNivelUp() async {}
  Future<void> playEfeitoClick() async {}
  Future<void> stopMusica() async {}
  void dispose() {}
}