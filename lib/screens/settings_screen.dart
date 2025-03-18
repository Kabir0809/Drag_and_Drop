import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../utils/audio_manager.dart';
import '../providers/game_provider.dart';
import '../utils/haptic_feedback.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
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
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // Sound settings
            _buildSettingsCard(
              title: 'Sound Settings',
              children: [
                // Sound effects toggle
                _buildToggleSetting(
                  icon: Icons.volume_up_rounded,
                  title: 'Sound Effects',
                  value: settings.soundEnabled,
                  onChanged: (value) {
                    settings.toggleSound();
                    AudioManager().updateSettings(
                      soundEnabled: settings.soundEnabled,
                      musicEnabled: settings.musicEnabled,
                      soundVolume: settings.soundVolume,
                      musicVolume: settings.musicVolume,
                    );
                  },
                ),
                
                // Sound volume slider
                if (settings.soundEnabled)
                  _buildSliderSetting(
                    title: 'Sound Volume',
                    value: settings.soundVolume,
                    onChanged: (value) {
                      settings.setSoundVolume(value);
                      AudioManager().updateSettings(
                        soundEnabled: settings.soundEnabled,
                        musicEnabled: settings.musicEnabled,
                        soundVolume: settings.soundVolume,
                        musicVolume: settings.musicVolume,
                      );
                    },
                  ),
                
                Divider(),
                
                // Music toggle
                _buildToggleSetting(
                  icon: Icons.music_note_rounded,
                  title: 'Background Music',
                  value: settings.musicEnabled,
                  onChanged: (value) {
                    settings.toggleMusic();
                    AudioManager().updateSettings(
                      soundEnabled: settings.soundEnabled,
                      musicEnabled: settings.musicEnabled,
                      soundVolume: settings.soundVolume,
                      musicVolume: settings.musicVolume,
                    );
                    
                    if (settings.musicEnabled) {
                      AudioManager().playMusic('assets/audio/background.mp3');
                    } else {
                      AudioManager().stopAll();
                    }
                  },
                ),
                
                // Music volume slider
                if (settings.musicEnabled)
                  _buildSliderSetting(
                    title: 'Music Volume',
                    value: settings.musicVolume,
                    onChanged: (value) {
                      settings.setMusicVolume(value);
                      AudioManager().updateSettings(
                        soundEnabled: settings.soundEnabled,
                        musicEnabled: settings.musicEnabled,
                        soundVolume: settings.soundVolume,
                        musicVolume: settings.musicVolume,
                      );
                    },
                  ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Haptic feedback settings
            _buildSettingsCard(
              title: 'Haptic Feedback',
              children: [
                _buildToggleSetting(
                  icon: Icons.vibration_rounded,
                  title: 'Vibration',
                  value: settings.hapticEnabled,
                  onChanged: (value) {
                    settings.toggleHaptic();
                    HapticFeedbackManager().updateSettings(
                      enabled: settings.hapticEnabled,
                    );
                  },
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Visual settings
            _buildSettingsCard(
              title: 'Visual Settings',
              children: [
                _buildToggleSetting(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  value: settings.darkMode,
                  onChanged: (value) {
                    settings.toggleDarkMode();
                  },
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // About section
            _buildSettingsCard(
              title: 'About',
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blue.shade800,
                  ),
                  title: Text(
                    'About Shape Matcher',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_rounded,
                    color: Colors.blue.shade800,
                  ),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                    ),
                  ),
                  onTap: () {
                    // Navigate to privacy policy
                  },
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Reset game data
            _buildSettingsCard(
              title: 'Game Data',
              children: [
                ListTile(
                  leading: Icon(
                    Icons.delete_rounded,
                    color: Colors.red.shade700,
                  ),
                  title: Text(
                    'Reset Progress',
                    style: TextStyle(
                      color: Colors.red.shade700,
                    ),
                  ),
                  onTap: () {
                    _showResetConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggleSetting({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.blue.shade800,
          size: 28,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue.shade700,
        ),
      ],
    );
  }
  
  Widget _buildSliderSetting({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 44),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
              activeColor: Colors.blue.shade700,
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
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
  
  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Progress'),
        content: Text('Are you sure you want to reset all game progress? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset game progress
              Provider.of<GameProvider>(context, listen: false).initGame();
              Navigator.pop(context);
              
              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Game progress has been reset.'),
                  backgroundColor: Colors.blue.shade700,
                ),
              );
            },
            child: Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}