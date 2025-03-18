import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import '../models/drag_item.dart';
import '../models/drop_zone.dart';
import '../services/level_generator.dart';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState();
  Timer? _gameTimer;
  final LevelGenerator _levelGenerator = LevelGenerator();
  
  GameState get gameState => _gameState;
  
  // Initialize the game
  void initGame() {
    _gameState = GameState();
    notifyListeners();
  }
  
  // Load a specific level
  void loadLevel(int levelId) {
    final level = _levelGenerator.generateLevel(levelId);
    _gameState = _gameState.copyWith(
      status: GameStatus.playing,
      currentLevelId: levelId,
      currentLevel: level,
      moves: 0,
      timeRemaining: level.timeLimit,
    );
    
    if (level.timeLimit > 0) {
      _startTimer();
    }
    
    notifyListeners();
  }
  
  // Start the game timer
  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameState.timeRemaining <= 0) {
        _gameTimer?.cancel();
        _gameState = _gameState.copyWith(
          status: GameStatus.gameOver,
        );
      } else {
        _gameState = _gameState.copyWith(
          timeRemaining: _gameState.timeRemaining - 1,
        );
      }
      notifyListeners();
    });
  }
  
  // Pause the game
  void pauseGame() {
    _gameTimer?.cancel();
    _gameState = _gameState.copyWith(
      status: GameStatus.paused,
    );
    notifyListeners();
  }
  
  // Resume the game
  void resumeGame() {
    if (_gameState.status == GameStatus.paused) {
      _gameState = _gameState.copyWith(
        status: GameStatus.playing,
      );
      
      if (_gameState.currentLevel!.timeLimit > 0 && _gameState.timeRemaining > 0) {
        _startTimer();
      }
      
      notifyListeners();
    }
  }
  
  // Handle item drag start
  void onDragStart(String itemId) {
    if (_gameState.currentLevel == null) return;
    
    final updatedItems = _gameState.currentLevel!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isDragging: true);
      }
      return item;
    }).toList();
    
    final updatedLevel = _gameState.currentLevel!;
    updatedLevel.items.clear();
    updatedLevel.items.addAll(updatedItems);
    
    _gameState = _gameState.copyWith(
      currentLevel: updatedLevel,
    );
    
    notifyListeners();
  }
  
  // Handle item drag end
  void onDragEnd(String itemId) {
    if (_gameState.currentLevel == null) return;
    
    final updatedItems = _gameState.currentLevel!.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isDragging: false);
      }
      return item;
    }).toList();
    
    final updatedLevel = _gameState.currentLevel!;
    updatedLevel.items.clear();
    updatedLevel.items.addAll(updatedItems);
    
    _gameState = _gameState.copyWith(
      currentLevel: updatedLevel,
    );
    
    notifyListeners();
  }
  
  // Handle item dropped on zone
  void onItemDropped(String itemId, String zoneId) {
    if (_gameState.currentLevel == null) return;
    
    final item = _gameState.currentLevel!.items.firstWhere((i) => i.id == itemId);
    final zone = _gameState.currentLevel!.dropZones.firstWhere((z) => z.id == zoneId);
    
    if (!zone.canAccept(item)) return;
    
    // Update the drop zone
    final updatedZones = _gameState.currentLevel!.dropZones.map((z) {
      if (z.id == zoneId) {
        return z.copyWith(occupiedBy: itemId);
      }
      return z;
    }).toList();
    
    // Update the item position to match the drop zone
    final updatedItems = _gameState.currentLevel!.items.map((i) {
      if (i.id == itemId) {
        return i.copyWith(
          position: zone.position,
          isDragging: false,
        );
      }
      return i;
    }).toList();
    
    final updatedLevel = _gameState.currentLevel!;
    updatedLevel.dropZones.clear();
    updatedLevel.dropZones.addAll(updatedZones);
    updatedLevel.items.clear();
    updatedLevel.items.addAll(updatedItems);
    
    _gameState = _gameState.copyWith(
      currentLevel: updatedLevel,
      moves: _gameState.moves + 1,
    );
    
    // Check if level is completed
    if (updatedLevel.isCompleted) {
      _onLevelCompleted();
    }
    
    notifyListeners();
  }
  
  // Handle level completion
  void _onLevelCompleted() {
    _gameTimer?.cancel();
    
    final score = _gameState.currentLevel!.calculateScore(
      _gameState.timeRemaining,
      _gameState.moves,
    );
    
    // Update level scores
    final updatedScores = Map<int, int>.from(_gameState.levelScores);
    final levelId = _gameState.currentLevelId;
    
    // Only update if new score is higher
    if (!updatedScores.containsKey(levelId) || updatedScores[levelId]! < score) {
      updatedScores[levelId] = score;
    }
    
    _gameState = _gameState.copyWith(
      status: GameStatus.levelCompleted,
      score: _gameState.score + score,
      levelScores: updatedScores,
    );
    
    notifyListeners();
  }
  
  // Reset current level
  void resetLevel() {
    loadLevel(_gameState.currentLevelId);
  }
  
  // Move to next level
  void nextLevel() {
    loadLevel(_gameState.currentLevelId + 1);
  }
  
  // Clean up resources
  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}