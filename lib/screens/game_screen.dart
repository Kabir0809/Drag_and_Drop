import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/status_panel.dart';
import '../widgets/control_panel.dart';
import '../utils/audio_manager.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final int levelId;
  
  const GameScreen({
    Key? key,
    required this.levelId,
  }) : super(key: key);
  
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize confetti controller
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    
    // Load the level
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).loadLevel(widget.levelId);
    });
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;
    
    // Show level complete overlay
    if (gameState.status == GameStatus.levelCompleted && _confettiController.state != ConfettiControllerState.playing) {
      _confettiController.play();
      AudioManager().playLevelComplete();
      
      // Show level complete dialog after a short delay
      Future.delayed(Duration(milliseconds: 500), () {
        _showLevelCompleteDialog(context, gameState);
      });
    }
    
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when trying to exit
        if (gameState.status == GameStatus.playing) {
          gameProvider.pauseGame();
          final result = await _showExitConfirmationDialog(context);
          if (result == true) {
            return true;
          } else {
            gameProvider.resumeGame();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: Column(
          children: [
            // Status panel (score, moves, timer)
            StatusPanel(),
            
            // Game board (main content)
            Expanded(
              child: Stack(
                children: [
                  // Game board with drag items and drop zones
                  GameBoard(),
                  
                  // Pause overlay
                  if (gameState.status == GameStatus.paused)
                    _buildPauseOverlay(),
                  
                  // Game over overlay
                  if (gameState.status == GameStatus.gameOver)
                    _buildGameOverOverlay(),
                  
                  // Confetti effect for level completion
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirection: pi / 2, // straight up
                      maxBlastForce: 20,
                      minBlastForce: 10,
                      emissionFrequency: 0.05,
                      numberOfParticles: 20,
                      gravity: 0.2,
                      colors: [
                        Colors.red,
                        Colors.green,
                        Colors.blue,
                        Colors.yellow,
                        Colors.purple,
                        Colors.orange,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Control panel (buttons)
            ControlPanel(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Paused',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPauseButton(
                    icon: Icons.play_arrow_rounded,
                    label: 'Resume',
                    onTap: () {
                      Provider.of<GameProvider>(context, listen: false).resumeGame();
                    },
                  ),
                  SizedBox(width: 16),
                  _buildPauseButton(
                    icon: Icons.refresh_rounded,
                    label: 'Restart',
                    onTap: () {
                      Provider.of<GameProvider>(context, listen: false).resetLevel();
                    },
                  ),
                  SizedBox(width: 16),
                  _buildPauseButton(
                    icon: Icons.home_rounded,
                    label: 'Exit',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Time\'s Up!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You ran out of time.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPauseButton(
                    icon: Icons.refresh_rounded,
                    label: 'Try Again',
                    onTap: () {
                      Provider.of<GameProvider>(context, listen: false).resetLevel();
                    },
                  ),
                  SizedBox(width: 16),
                  _buildPauseButton(
                    icon: Icons.home_rounded,
                    label: 'Exit',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPauseButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.blue.shade800,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _showLevelCompleteDialog(BuildContext context, GameState gameState) async {
    final int score = gameState.levelScores[gameState.currentLevelId] ?? 0;
    final int stars = _calculateStars(score, gameState.currentLevel?.starThresholds ?? 300);
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: index < stars ? Colors.amber : Colors.grey.shade400,
                  size: 36,
                );
              }),
            ),
            SizedBox(height: 20),
            
            // Score
            Text(
              'Score: $score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 8),
            
            // Moves
            Text(
              'Moves: ${gameState.moves}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            
            // Time bonus (if applicable)
            if ((gameState.currentLevel?.timeLimit ?? 0) > 0)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Time Bonus: ${gameState.timeRemaining * 10}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to level select
            },
            child: Text('Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<GameProvider>(context, listen: false).resetLevel();
            },
            child: Text('Replay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<GameProvider>(context, listen: false).nextLevel();
            },
            child: Text('Next Level'),
          ),
        ],
      ),
    );
  }
  
  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Level?'),
        content: Text('Are you sure you want to exit? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
  
  int _calculateStars(int score, int threshold) {
    if (score >= threshold) {
      return 3;
    } else if (score >= threshold * 0.7) {
      return 2;
    } else if (score >= threshold * 0.4) {
      return 1;
    } else {
      return 0;
    }
  }
}