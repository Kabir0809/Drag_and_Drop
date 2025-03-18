import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
class ControlPanel extends StatelessWidget {
  const ControlPanel({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Pause/Resume button
            _buildControlButton(
              icon: gameState.status == GameStatus.paused
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
              label: gameState.status == GameStatus.paused ? 'Resume' : 'Pause',
              onTap: () {
                if (gameState.status == GameStatus.paused) {
                  gameProvider.resumeGame();
                } else {
                  gameProvider.pauseGame();
                }
              },
            ),
            
            // Reset button
            _buildControlButton(
              icon: Icons.refresh_rounded,
              label: 'Reset',
              onTap: () {
                gameProvider.resetLevel();
              },
            ),
            
            // Settings button
            _buildControlButton(
              icon: Icons.settings_rounded,
              label: 'Settings',
              onTap: () {
                // Navigate to settings
                Navigator.pushNamed(context, '/settings');
              },
            ),
            
            // Help button
            _buildControlButton(
              icon: Icons.help_outline_rounded,
              label: 'Help',
              onTap: () {
                _showHelpDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.blue.shade800,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('How to Play'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Drag the shapes to their matching outlines.'),
            SizedBox(height: 8),
            Text('2. Match all shapes to complete the level.'),
            SizedBox(height: 8),
            Text('3. Complete levels faster for higher scores.'),
            SizedBox(height: 8),
            Text('4. Use fewer moves for bonus points.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it!'),
          ),
        ],
      ),
    );
  }
}