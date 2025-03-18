import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final levelScores = gameProvider.gameState.levelScores;
    
    // Total number of levels
    final int totalLevels = 15;
    
    // Number of unlocked levels (player can play level N+1 if they've completed level N)
    int unlockedLevels = 1;
    for (int i = 1; i <= totalLevels; i++) {
      if (levelScores.containsKey(i)) {
        unlockedLevels = i + 1;
      } else {
        break;
      }
    }
    
    // Ensure we don't unlock beyond the total
    unlockedLevels = unlockedLevels.clamp(1, totalLevels);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Level',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: totalLevels,
            itemBuilder: (context, index) {
              final levelId = index + 1;
              final bool isUnlocked = levelId <= unlockedLevels;
              final bool isCompleted = levelScores.containsKey(levelId);
              final int stars = isCompleted
                  ? _calculateStars(levelScores[levelId]!, 300 + (levelId * 50))
                  : 0;
              
              return _buildLevelTile(
                context: context,
                levelId: levelId,
                isUnlocked: isUnlocked,
                isCompleted: isCompleted,
                stars: stars,
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildLevelTile({
    required BuildContext context,
    required int levelId,
    required bool isUnlocked,
    required bool isCompleted,
    required int stars,
  }) {
    return InkWell(
      onTap: isUnlocked
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(levelId: levelId),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? Colors.white.withOpacity(0.9)
              : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level number
            Text(
              '$levelId',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isUnlocked
                    ? Colors.blue.shade800
                    : Colors.grey.shade600,
              ),
            ),
            
            SizedBox(height: 8),
            
            // Stars (if completed)
            if (isCompleted)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: index < stars ? Colors.amber : Colors.grey.shade400,
                    size: 18,
                  );
                }),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    Icons.star_border,
                    color: Colors.grey.shade400,
                    size: 18,
                  );
                }),
              ),
            
            // Lock icon for locked levels
            if (!isUnlocked)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.lock_rounded,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
              ),
          ],
        ),
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