import 'package:flutter/services.dart';

class HapticFeedbackManager {
  static final HapticFeedbackManager _instance = HapticFeedbackManager._internal();
  factory HapticFeedbackManager() => _instance;
  
  HapticFeedbackManager._internal();
  
  bool _enabled = true;
  
  void updateSettings({required bool enabled}) {
    _enabled = enabled;
  }
  
  Future<void> init() async {
    await HapticFeedback.vibrate();
  }
  
  void lightImpact() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
  }
  
  void mediumImpact() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }
  
  void heavyImpact() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }
  
  void dragStart() {
    lightImpact();
  }
  
  void dragEnd() {
    lightImpact();
  }
  
  void correctDrop() {
    mediumImpact();
  }
  
  void incorrectDrop() {
    heavyImpact();
  }
  
  void levelComplete() {
    HapticFeedback.vibrate();
  }
}