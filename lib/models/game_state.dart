import 'level.dart';

enum GameStatus { menu, playing, paused, levelCompleted, gameOver }

class GameState {
  final GameStatus status;
  final int currentLevelId;
  final Level? currentLevel;
  final int score;
  final int moves;
  final int timeRemaining;
  final Map<int, int> levelScores; // level id -> score
  final int lives;
  
  GameState({
    this.status = GameStatus.menu,
    this.currentLevelId = 1,
    this.currentLevel,
    this.score = 0,
    this.moves = 0,
    this.timeRemaining = 0,
    this.levelScores = const {},
    this.lives = 3,
  });
  
  GameState copyWith({
    GameStatus? status,
    int? currentLevelId,
    Level? currentLevel,
    int? score,
    int? moves,
    int? timeRemaining,
    Map<int, int>? levelScores,
    int? lives,
  }) {
    return GameState(
      status: status ?? this.status,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      currentLevel: currentLevel ?? this.currentLevel,
      score: score ?? this.score,
      moves: moves ?? this.moves,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      levelScores: levelScores ?? this.levelScores,
      lives: lives ?? this.lives,
    );
  }
}