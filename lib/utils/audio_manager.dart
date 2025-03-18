import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  
  AudioManager._internal();
  
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;
  
  // Initialize audio
  Future<void> init() async {
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _effectPlayer.setReleaseMode(ReleaseMode.release);
  }
  
  // Update settings
  void updateSettings({
    required bool soundEnabled,
    required bool musicEnabled,
    required double soundVolume,
    required double musicVolume,
  }) {
    _soundEnabled = soundEnabled;
    _musicEnabled = musicEnabled;
    _soundVolume = soundVolume;
    _musicVolume = musicVolume;
    
    _musicPlayer.setVolume(_musicEnabled ? _musicVolume : 0);
  }
  
  // Play background music
  Future<void> playMusic(String assetPath) async {
    if (!_musicEnabled) return;
    
    await _musicPlayer.stop();
    await _musicPlayer.setSourceAsset(assetPath);
    await _musicPlayer.setVolume(_musicVolume);
    await _musicPlayer.resume();
  }
  
  // Play sound effect
  Future<void> playEffect(String assetPath) async {
    if (!_soundEnabled) return;
    
    await _effectPlayer.stop();
    await _effectPlayer.setSourceAsset(assetPath);
    await _effectPlayer.setVolume(_soundVolume);
    await _effectPlayer.resume();
  }
  
  // Play different effects based on action
  Future<void> playDragStart() async {
    await playEffect('assets/audio/drag_start.mp3');
  }
  
  Future<void> playDragEnd() async {
    await playEffect('assets/audio/drag_end.mp3');
  }
  
  Future<void> playCorrectDrop() async {
    await playEffect('assets/audio/correct_drop.mp3');
  }
  
  Future<void> playIncorrectDrop() async {
    await playEffect('assets/audio/incorrect_drop.mp3');
  }
  
  Future<void> playLevelComplete() async {
    await playEffect('assets/audio/level_complete.mp3');
  }
  
  // Stop all audio
  Future<void> stopAll() async {
    await _musicPlayer.stop();
    await _effectPlayer.stop();
  }
  
  // Dispose resources
  Future<void> dispose() async {
    await _musicPlayer.dispose();
    await _effectPlayer.dispose();
  }
}