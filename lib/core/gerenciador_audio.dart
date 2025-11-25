import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late final AudioPlayer _bgPlayer;
  late final AudioPlayer _sfxPlayer;

  bool _enabled = true;

  AudioManager._internal() {
    _bgPlayer = AudioPlayer(playerId: 'bg_music');
    _sfxPlayer = AudioPlayer(playerId: 'sfx');
  }

  Future<void> init() async {
    await _bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> playBackground() async {
    if (!_enabled) return;
    await _bgPlayer.setSource(AssetSource('audio/bg_music.mp3'));
    await _bgPlayer.resume();
  }

  Future<void> stopBackground() async {
    await _bgPlayer.stop();
  }

  Future<void> playSfx(String file) async {
    if (!_enabled) return;
    await _sfxPlayer.play(AssetSource('audio/$file'));
  }

  void toggleAudio() {
    _enabled = !_enabled;
    if (!_enabled) {
      stopBackground();
    } else {
      playBackground();
    }
  }
}
