import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/audio_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Game title
              Text(
                'Shape Matcher',
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Drag & Drop Puzzle Game',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 60),
              
              // Play button
              _buildMenuButton(
                context: context,
                icon: Icons.play_arrow_rounded,
                label: 'Play',
                onTap: () {
                  Navigator.pushNamed(context, '/level_select');
                },
              ),
              SizedBox(height: 20),
              
              // Settings button
              _buildMenuButton(
                context: context,
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              SizedBox(height: 20),
              
              // About button
              _buildMenuButton(
                context: context,
                icon: Icons.info_outline_rounded,
                label: 'About',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              
              SizedBox(height: 60),
              
              // Sound toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      settings.soundEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      settings.toggleSound();
                    },
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      settings.musicEnabled
                          ? Icons.music_note_rounded
                          : Icons.music_off_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      settings.toggleMusic();
                      if (settings.musicEnabled) {
                        AudioManager().playMusic('assets/audio/background.mp3');
                      } else {
                        AudioManager().stopAll();
                      }
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
  
  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About Shape Matcher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A drag and drop puzzle game created with Flutter.'),
            SizedBox(height: 16),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Developer: Your Name'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}