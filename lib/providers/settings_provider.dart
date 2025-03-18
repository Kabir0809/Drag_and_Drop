import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _hapticEnabled = true;
  bool _darkMode = false;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;
  
  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get hapticEnabled => _hapticEnabled;
  bool get darkMode => _darkMode;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  // Load settings from local storage
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _musicEnabled = prefs.getBool('musicEnabled') ?? true;
    _hapticEnabled = prefs.getBool('hapticEnabled') ?? true;
    _darkMode = prefs.getBool('darkMode') ?? false;
    _soundVolume = prefs.getDouble('soundVolume') ?? 1.0;
    _musicVolume = prefs.getDouble('musicVolume') ?? 0.7;
    notifyListeners();
  }
  
  // Save settings to local storage
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', _soundEnabled);
    await prefs.setBool('musicEnabled', _musicEnabled);
    await prefs.setBool('hapticEnabled', _hapticEnabled);
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setDouble('soundVolume', _soundVolume);
    await prefs.setDouble('musicVolume', _musicVolume);
  }
  
  // Toggle sound effects
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle background music
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle haptic feedback
  void toggleHaptic() {
    _hapticEnabled = !_hapticEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // Toggle dark mode
  void toggleDarkMode() {
    _darkMode = !_darkMode;
    _saveSettings();
    notifyListeners();
  }
  
  // Set sound volume
  void setSoundVolume(double volume) {
    _soundVolume = volume;
    _saveSettings();
    notifyListeners();
  }
  
  // Set music volume
  void setMusicVolume(double volume) {
    _musicVolume = volume;
    _saveSettings();
    notifyListeners();
  }
}