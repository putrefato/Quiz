import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

class GerenciadorAudio {
  static final GerenciadorAudio _instancia = GerenciadorAudio._interno();
  factory GerenciadorAudio() => _instancia;
  GerenciadorAudio._interno();

  final AudioPlayer _playerMusica = AudioPlayer();
  final AudioPlayer _playerEfeitos = AudioPlayer();

  bool _musicaAtiva = true;
  bool _efeitosAtivos = true;
  double _volumeMusica = 0.7;
  double _volumeEfeitos = 1.0;

  // Getters
  bool get musicaAtiva => _musicaAtiva;
  bool get efeitosAtivos => _efeitosAtivos;
  double get volumeMusica => _volumeMusica;
  double get volumeEfeitos => _volumeEfeitos;

  // Sons simples com beeps
  Future<void> _tocarBeep(double frequencia, int duracao) async {
    if (!_efeitosAtivos) return;
    // Simula um beep básico
    print('🔊 Beep: ${frequencia}Hz por ${duracao}ms');
  }

  Future<void> playEfeitoAcerto() async {
    await _tocarBeep(880, 300); // Lá alto
  }

  Future<void> playEfeitoErro() async {
    await _tocarBeep(220, 500); // Lá baixo
  }

  Future<void> playEfeitoClick() async {
    await _tocarBeep(440, 100); // Lá médio
  }

  Future<void> playEfeitoNivelUp() async {
    if (!_efeitosAtivos) return;
    // Sequência de beeps ascendente
    for (int i = 0; i < 3; i++) {
      await _tocarBeep(440 + (i * 110), 200);
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> playMusicaTema() async {
    if (!_musicaAtiva) return;
    print('🎵 Tocando música tema');

    // Música simples em loop
    final List<double> notas = [261.63, 329.63, 392.00, 523.25];
    for (double nota in notas) {
      if (!_musicaAtiva) break;
      await _tocarBeep(nota, 400);
      await Future.delayed(Duration(milliseconds: 200));
    }
    
    if (_musicaAtiva) {
      playMusicaTema(); // Loop
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

  void setEfeitosAtivos(bool ativos) => _efeitosAtivos = ativos;
  void setVolumeMusica(double volume) => _volumeMusica = volume;
  void setVolumeEfeitos(double volume) => _volumeEfeitos = volume;

  void dispose() {
    _playerMusica.dispose();
    _playerEfeitos.dispose();
  }
}