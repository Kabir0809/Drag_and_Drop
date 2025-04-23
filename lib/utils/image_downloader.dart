import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImageDownloader {
  static final Map<String, String> _imageUrls = {
    // Animals
    'assets/images/animals/lion.png': 'https://example.com/lion.png',
    'assets/images/animals/elephant.png': 'https://example.com/elephant.png',
    'assets/images/animals/giraffe.png': 'https://example.com/giraffe.png',
    'assets/images/animals/zebra.png': 'https://example.com/zebra.png',
    'assets/images/animals/tiger.png': 'https://example.com/tiger.png',
    
    // Numbers
    'assets/images/numbers/1.png': 'https://example.com/1.png',
    'assets/images/numbers/2.png': 'https://example.com/2.png',
    'assets/images/numbers/3.png': 'https://example.com/3.png',
    'assets/images/numbers/4.png': 'https://example.com/4.png',
    'assets/images/numbers/5.png': 'https://example.com/5.png',
    
    // Landmarks
    'assets/images/landmarks/eiffel.png': 'https://example.com/eiffel.png',
    'assets/images/landmarks/liberty.png': 'https://example.com/liberty.png',
    'assets/images/landmarks/wall.png': 'https://example.com/wall.png',
    'assets/images/landmarks/pyramids.png': 'https://example.com/pyramids.png',
    'assets/images/landmarks/taj.png': 'https://example.com/taj.png',
    
    // Sports
    'assets/images/sports/football.png': 'https://example.com/football.png',
    'assets/images/sports/basketball.png': 'https://example.com/basketball.png',
    'assets/images/sports/tennis.png': 'https://example.com/tennis.png',
    'assets/images/sports/swimming.png': 'https://example.com/swimming.png',
    'assets/images/sports/golf.png': 'https://example.com/golf.png',
  };

  static Future<void> downloadImages() async {
    for (final entry in _imageUrls.entries) {
      final filePath = entry.key;
      final url = entry.value;
      
      // Create directory if it doesn't exist
      final directory = path.dirname(filePath);
      await Directory(directory).create(recursive: true);
      
      try {
        // Download the image with a timeout
        final response = await http.get(Uri.parse(url))
            .timeout(Duration(seconds: 10));
            
        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          print('Downloaded: $filePath');
        } else {
          print('Failed to download: $filePath (Status: ${response.statusCode})');
        }
      } catch (e) {
        print('Error downloading: $filePath (Error: $e)');
      }
    }
  }
} 