import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';
import 'screens/level_select.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';
import 'utils/audio_manager.dart';
import 'utils/haptic_feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await AudioManager().init();
  await HapticFeedbackManager().init();
  
  runApp(const DragDropPuzzleApp());
}

class DragDropPuzzleApp extends StatelessWidget {
  const DragDropPuzzleApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Shape Matcher',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: settings.darkMode ? Brightness.dark : Brightness.light,
              fontFamily: GoogleFonts.poppins().fontFamily,
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => HomeScreen(),
              '/level_select': (context) => LevelSelectScreen(),
              '/settings': (context) => SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}