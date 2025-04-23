import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class IconDownloader {
  static const Map<String, String> _iconUrls = {
    // Vehicles
    'assets/images/vehicles/car.png': 'https://cdn-icons-png.flaticon.com/128/3774/3774278.png',
    'assets/images/vehicles/bike.png': 'https://cdn-icons-png.flaticon.com/128/2972/2972185.png',
    'assets/images/vehicles/plane.png': 'https://cdn-icons-png.flaticon.com/128/3125/3125713.png',
    'assets/images/vehicles/boat.png': 'https://cdn-icons-png.flaticon.com/128/2258/2258825.png',
    'assets/images/vehicles/train.png': 'https://cdn-icons-png.flaticon.com/128/3066/3066259.png',

    // Furniture
    'assets/images/furniture/chair.png': 'https://cdn-icons-png.flaticon.com/128/2929/2929032.png',
    'assets/images/furniture/table.png': 'https://cdn-icons-png.flaticon.com/128/2929/2929069.png',
    'assets/images/furniture/bed.png': 'https://cdn-icons-png.flaticon.com/128/2400/2400421.png',
    'assets/images/furniture/sofa.png': 'https://cdn-icons-png.flaticon.com/128/2400/2400425.png',
    'assets/images/furniture/wardrobe.png': 'https://cdn-icons-png.flaticon.com/128/2400/2400419.png',

    // Food
    'assets/images/food/pizza.png': 'https://cdn-icons-png.flaticon.com/128/3132/3132693.png',
    'assets/images/food/burger.png': 'https://cdn-icons-png.flaticon.com/128/3075/3075977.png',
    'assets/images/food/icecream.png': 'https://cdn-icons-png.flaticon.com/128/3075/3075931.png',
    'assets/images/food/apple.png': 'https://cdn-icons-png.flaticon.com/128/415/415733.png',
    'assets/images/food/cake.png': 'https://cdn-icons-png.flaticon.com/128/3075/3075856.png',

    // Instruments
    'assets/images/instruments/guitar.png': 'https://cdn-icons-png.flaticon.com/128/3659/3659784.png',
    'assets/images/instruments/piano.png': 'https://cdn-icons-png.flaticon.com/128/3659/3659783.png',
    'assets/images/instruments/drums.png': 'https://cdn-icons-png.flaticon.com/128/3659/3659785.png',
    'assets/images/instruments/violin.png': 'https://cdn-icons-png.flaticon.com/128/3659/3659782.png',
    'assets/images/instruments/flute.png': 'https://cdn-icons-png.flaticon.com/128/3659/3659781.png',

    // Clothing
    'assets/images/clothing/shirt.png': 'https://cdn-icons-png.flaticon.com/128/2503/2503380.png',
    'assets/images/clothing/pants.png': 'https://cdn-icons-png.flaticon.com/128/2503/2503381.png',
    'assets/images/clothing/shoes.png': 'https://cdn-icons-png.flaticon.com/128/2589/2589903.png',
    'assets/images/clothing/hat.png': 'https://cdn-icons-png.flaticon.com/128/1974/1974211.png',
    'assets/images/clothing/jacket.png': 'https://cdn-icons-png.flaticon.com/128/2405/2405607.png',

    // Weather
    'assets/images/weather/sun.png': 'https://cdn-icons-png.flaticon.com/128/869/869869.png',
    'assets/images/weather/rain.png': 'https://cdn-icons-png.flaticon.com/128/3351/3351979.png',
    'assets/images/weather/snow.png': 'https://cdn-icons-png.flaticon.com/128/642/642000.png',
    'assets/images/weather/cloud.png': 'https://cdn-icons-png.flaticon.com/128/414/414927.png',
    'assets/images/weather/storm.png': 'https://cdn-icons-png.flaticon.com/128/1146/1146860.png',

    // Shapes
    'assets/images/shapes/circle.png': 'https://cdn-icons-png.flaticon.com/128/481/481662.png',
    'assets/images/shapes/square.png': 'https://cdn-icons-png.flaticon.com/128/33/33848.png',
    'assets/images/shapes/triangle.png': 'https://cdn-icons-png.flaticon.com/128/33/33893.png',
    'assets/images/shapes/rectangle.png': 'https://cdn-icons-png.flaticon.com/128/33/33849.png',
    'assets/images/shapes/star.png': 'https://cdn-icons-png.flaticon.com/128/1828/1828884.png',

    // Colors
    'assets/images/colors/red.png': 'https://cdn-icons-png.flaticon.com/128/3103/3103231.png',
    'assets/images/colors/blue.png': 'https://cdn-icons-png.flaticon.com/128/3103/3103231.png',
    'assets/images/colors/green.png': 'https://cdn-icons-png.flaticon.com/128/3103/3103231.png',
    'assets/images/colors/yellow.png': 'https://cdn-icons-png.flaticon.com/128/3103/3103231.png',
    'assets/images/colors/purple.png': 'https://cdn-icons-png.flaticon.com/128/3103/3103231.png',

    // Jobs
    'assets/images/jobs/doctor.png': 'https://cdn-icons-png.flaticon.com/128/3774/3774299.png',
    'assets/images/jobs/teacher.png': 'https://cdn-icons-png.flaticon.com/128/1995/1995574.png',
    'assets/images/jobs/chef.png': 'https://cdn-icons-png.flaticon.com/128/1995/1995571.png',
    'assets/images/jobs/police.png': 'https://cdn-icons-png.flaticon.com/128/1995/1995578.png',
    'assets/images/jobs/firefighter.png': 'https://cdn-icons-png.flaticon.com/128/1995/1995577.png',

    // Seasons
    'assets/images/seasons/spring.png': 'https://cdn-icons-png.flaticon.com/128/1825/1825210.png',
    'assets/images/seasons/summer.png': 'https://cdn-icons-png.flaticon.com/128/1825/1825209.png',
    'assets/images/seasons/autumn.png': 'https://cdn-icons-png.flaticon.com/128/1825/1825208.png',
    'assets/images/seasons/winter.png': 'https://cdn-icons-png.flaticon.com/128/1825/1825207.png',

    // Emotions
    'assets/images/emotions/happy.png': 'https://cdn-icons-png.flaticon.com/128/742/742751.png',
    'assets/images/emotions/sad.png': 'https://cdn-icons-png.flaticon.com/128/742/742752.png',
    'assets/images/emotions/angry.png': 'https://cdn-icons-png.flaticon.com/128/742/742744.png',
    'assets/images/emotions/surprised.png': 'https://cdn-icons-png.flaticon.com/128/742/742750.png',
    'assets/images/emotions/scared.png': 'https://cdn-icons-png.flaticon.com/128/742/742753.png',
  };

  static Future<void> downloadIcons() async {
    for (final entry in _iconUrls.entries) {
      final filePath = entry.key;
      final url = entry.value;
      
      try {
        // Create directory if it doesn't exist
        final directory = Directory(path.dirname(filePath));
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        
        // Download the image
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
          print('Successfully downloaded: $filePath');
        } else {
          print('Failed to download: $filePath (Status: ${response.statusCode})');
        }
      } catch (e) {
        print('Error downloading $filePath: $e');
      }
    }
  }
} 