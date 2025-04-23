import 'dart:math';
import 'package:flutter/material.dart';
import '../models/level.dart';
import '../models/drag_item.dart';
import '../models/drop_zone.dart';

class LevelGenerator {
  final Random _random = Random();
  
  // Color palette for items and zones
  final List<Color> _itemColors = [
    Colors.red.shade600,
    Colors.blue.shade600,
    Colors.green.shade600,
    Colors.orange.shade600,
    Colors.purple.shade600,
    Colors.teal.shade600,
    Colors.amber.shade600,
    Colors.indigo.shade600,
    Colors.pink.shade600,
    Colors.cyan.shade600,
    Colors.lime.shade600,
    Colors.brown.shade600,
  ];
  
  // Data for different categories
  final Map<ItemType, List<Map<String, String>>> _categoryData = {
    ItemType.animal: [
      {'name': 'Lion', 'image': 'assets/images/animals/lion.png', 'description': 'The king of the jungle'},
      {'name': 'Elephant', 'image': 'assets/images/animals/elephant.png', 'description': 'The largest land animal'},
      {'name': 'Giraffe', 'image': 'assets/images/animals/giraffe.png', 'description': 'The tallest land animal'},
      {'name': 'Zebra', 'image': 'assets/images/animals/zebra.png', 'description': 'Striped African horse'},
      {'name': 'Tiger', 'image': 'assets/images/animals/tiger.png', 'description': 'Striped big cat'},
    ],
    ItemType.number: [
      {'name': 'One', 'image': 'assets/images/numbers/1.png', 'description': 'First number'},
      {'name': 'Two', 'image': 'assets/images/numbers/2.png', 'description': 'Second number'},
      {'name': 'Three', 'image': 'assets/images/numbers/3.png', 'description': 'Third number'},
      {'name': 'Four', 'image': 'assets/images/numbers/4.png', 'description': 'Fourth number'},
      {'name': 'Five', 'image': 'assets/images/numbers/5.png', 'description': 'Fifth number'},
    ],
    ItemType.landmark: [
      {'name': 'Eiffel Tower', 'image': 'assets/images/landmarks/eiffel.png', 'description': 'Paris, France'},
      {'name': 'Statue of Liberty', 'image': 'assets/images/landmarks/liberty.png', 'description': 'New York, USA'},
      {'name': 'Great Wall', 'image': 'assets/images/landmarks/wall.png', 'description': 'China'},
      {'name': 'Pyramids', 'image': 'assets/images/landmarks/pyramids.png', 'description': 'Egypt'},
      {'name': 'Taj Mahal', 'image': 'assets/images/landmarks/taj.png', 'description': 'India'},
    ],
    ItemType.sport: [
      {'name': 'Football', 'image': 'assets/images/sports/football.png', 'description': 'Soccer'},
      {'name': 'Basketball', 'image': 'assets/images/sports/basketball.png', 'description': 'NBA'},
      {'name': 'Tennis', 'image': 'assets/images/sports/tennis.png', 'description': 'Wimbledon'},
      {'name': 'Swimming', 'image': 'assets/images/sports/swimming.png', 'description': 'Olympic sport'},
      {'name': 'Golf', 'image': 'assets/images/sports/golf.png', 'description': '18 holes'},
    ],
    ItemType.vehicle: [
      {'name': 'Car', 'image': 'assets/images/vehicles/car.png', 'description': 'Four-wheeled vehicle'},
      {'name': 'Bike', 'image': 'assets/images/vehicles/bike.png', 'description': 'Two-wheeled vehicle'},
      {'name': 'Plane', 'image': 'assets/images/vehicles/plane.png', 'description': 'Flying vehicle'},
      {'name': 'Boat', 'image': 'assets/images/vehicles/boat.png', 'description': 'Water vehicle'},
      {'name': 'Train', 'image': 'assets/images/vehicles/train.png', 'description': 'Rail vehicle'},
    ],
    ItemType.furniture: [
      {'name': 'Chair', 'image': 'assets/images/furniture/chair.png', 'description': 'For sitting'},
      {'name': 'Table', 'image': 'assets/images/furniture/table.png', 'description': 'For placing items'},
      {'name': 'Bed', 'image': 'assets/images/furniture/bed.png', 'description': 'For sleeping'},
      {'name': 'Sofa', 'image': 'assets/images/furniture/sofa.png', 'description': 'For sitting multiple people'},
      {'name': 'Wardrobe', 'image': 'assets/images/furniture/wardrobe.png', 'description': 'For storing clothes'},
    ],
    ItemType.food: [
      {'name': 'Pizza', 'image': 'assets/images/food/pizza.png', 'description': 'Italian dish'},
      {'name': 'Burger', 'image': 'assets/images/food/burger.png', 'description': 'Fast food'},
      {'name': 'Ice Cream', 'image': 'assets/images/food/icecream.png', 'description': 'Frozen dessert'},
      {'name': 'Apple', 'image': 'assets/images/food/apple.png', 'description': 'Fruit'},
      {'name': 'Cake', 'image': 'assets/images/food/cake.png', 'description': 'Sweet dessert'},
    ],
    ItemType.instrument: [
      {'name': 'Guitar', 'image': 'assets/images/instruments/guitar.png', 'description': 'String instrument'},
      {'name': 'Piano', 'image': 'assets/images/instruments/piano.png', 'description': 'Keyboard instrument'},
      {'name': 'Drums', 'image': 'assets/images/instruments/drums.png', 'description': 'Percussion instrument'},
      {'name': 'Violin', 'image': 'assets/images/instruments/violin.png', 'description': 'String instrument'},
      {'name': 'Flute', 'image': 'assets/images/instruments/flute.png', 'description': 'Wind instrument'},
    ],
    ItemType.clothing: [
      {'name': 'Shirt', 'image': 'assets/images/clothing/shirt.png', 'description': 'Upper body garment'},
      {'name': 'Pants', 'image': 'assets/images/clothing/pants.png', 'description': 'Lower body garment'},
      {'name': 'Shoes', 'image': 'assets/images/clothing/shoes.png', 'description': 'Footwear'},
      {'name': 'Hat', 'image': 'assets/images/clothing/hat.png', 'description': 'Headwear'},
      {'name': 'Jacket', 'image': 'assets/images/clothing/jacket.png', 'description': 'Outerwear'},
    ],
    ItemType.weather: [
      {'name': 'Sun', 'image': 'assets/images/weather/sun.png', 'description': 'Sunny weather'},
      {'name': 'Rain', 'image': 'assets/images/weather/rain.png', 'description': 'Rainy weather'},
      {'name': 'Snow', 'image': 'assets/images/weather/snow.png', 'description': 'Snowy weather'},
      {'name': 'Cloud', 'image': 'assets/images/weather/cloud.png', 'description': 'Cloudy weather'},
      {'name': 'Storm', 'image': 'assets/images/weather/storm.png', 'description': 'Stormy weather'},
    ],
    ItemType.shape: [
      {'name': 'Circle', 'image': 'assets/images/shapes/circle.png', 'description': 'Round shape'},
      {'name': 'Square', 'image': 'assets/images/shapes/square.png', 'description': 'Four equal sides'},
      {'name': 'Triangle', 'image': 'assets/images/shapes/triangle.png', 'description': 'Three sides'},
      {'name': 'Rectangle', 'image': 'assets/images/shapes/rectangle.png', 'description': 'Four sides'},
      {'name': 'Star', 'image': 'assets/images/shapes/star.png', 'description': 'Pointed shape'},
    ],
    ItemType.color: [
      {'name': 'Red', 'image': 'assets/images/colors/red.png', 'description': 'Primary color'},
      {'name': 'Blue', 'image': 'assets/images/colors/blue.png', 'description': 'Primary color'},
      {'name': 'Green', 'image': 'assets/images/colors/green.png', 'description': 'Secondary color'},
      {'name': 'Yellow', 'image': 'assets/images/colors/yellow.png', 'description': 'Primary color'},
      {'name': 'Purple', 'image': 'assets/images/colors/purple.png', 'description': 'Secondary color'},
    ],
    ItemType.job: [
      {'name': 'Doctor', 'image': 'assets/images/jobs/doctor.png', 'description': 'Medical professional'},
      {'name': 'Teacher', 'image': 'assets/images/jobs/teacher.png', 'description': 'Educator'},
      {'name': 'Chef', 'image': 'assets/images/jobs/chef.png', 'description': 'Cooking professional'},
      {'name': 'Police', 'image': 'assets/images/jobs/police.png', 'description': 'Law enforcement'},
      {'name': 'Firefighter', 'image': 'assets/images/jobs/firefighter.png', 'description': 'Emergency responder'},
    ],
    ItemType.season: [
      {'name': 'Spring', 'image': 'assets/images/seasons/spring.png', 'description': 'Season of growth'},
      {'name': 'Summer', 'image': 'assets/images/seasons/summer.png', 'description': 'Hot season'},
      {'name': 'Autumn', 'image': 'assets/images/seasons/autumn.png', 'description': 'Fall season'},
      {'name': 'Winter', 'image': 'assets/images/seasons/winter.png', 'description': 'Cold season'},
    ],
    ItemType.emotion: [
      {'name': 'Happy', 'image': 'assets/images/emotions/happy.png', 'description': 'Feeling joy'},
      {'name': 'Sad', 'image': 'assets/images/emotions/sad.png', 'description': 'Feeling sorrow'},
      {'name': 'Angry', 'image': 'assets/images/emotions/angry.png', 'description': 'Feeling mad'},
      {'name': 'Surprised', 'image': 'assets/images/emotions/surprised.png', 'description': 'Feeling amazed'},
      {'name': 'Scared', 'image': 'assets/images/emotions/scared.png', 'description': 'Feeling fear'},
    ],
  };
  
  // Generate a level based on level ID
  Level generateLevel(int levelId) {
    // Determine difficulty level
    final int difficultyLevel = (levelId - 1) ~/ 15; // 0 = Easy, 1 = Medium, 2 = Hard
    final int levelInDifficulty = (levelId - 1) % 15 + 1;
    
    // Get all categories for the current difficulty
    final List<ItemType> availableCategories = _getCategoriesForDifficulty(difficultyLevel);
    
    // Select a random category for this level
    final ItemType category = availableCategories[_random.nextInt(availableCategories.length)];
    
    // Adjust item count based on difficulty
    final int baseItemCount = 3;
    final int itemCount = min(baseItemCount + (difficultyLevel * 2), 5);
    
    // Adjust time limit based on difficulty
    final bool useTimer = levelId > 2;
    final int baseTimeLimit = 60;
    final int timeLimit = useTimer ? baseTimeLimit + (difficultyLevel * 30) : 0;
    
    // Get data for the category and shuffle it
    final List<Map<String, String>> categoryItems = List.from(_categoryData[category] ?? [])..shuffle(_random);
    final selectedItems = categoryItems.take(itemCount).toList();
    
    // Generate drop zones
    final List<DropZone> dropZones = _generateDropZones(selectedItems, levelId, category);
    
    // Generate draggable items
    final List<DragItem> items = _generateItems(selectedItems, levelId, category);
    
    return Level(
      id: levelId,
      name: 'Level $levelId',
      description: _generateDescription(levelId, category),
      timeLimit: timeLimit,
      items: items,
      dropZones: dropZones,
      starThresholds: itemCount * 100,
      specialRules: _generateSpecialRules(levelId),
    );
  }
  
  List<ItemType> _getCategoriesForDifficulty(int difficultyLevel) {
    switch (difficultyLevel) {
      case 0: // Easy
        return [
          ItemType.animal,
          ItemType.number,
          ItemType.shape,
          ItemType.color,
          ItemType.food,
        ];
      case 1: // Medium
        return [
          ItemType.landmark,
          ItemType.sport,
          ItemType.vehicle,
          ItemType.furniture,
          ItemType.instrument,
          ItemType.clothing,
          ItemType.weather,
        ];
      case 2: // Hard
        return [
          ItemType.job,
          ItemType.season,
          ItemType.emotion,
        ];
      default:
        return ItemType.values;
    }
  }
  
  List<DropZone> _generateDropZones(List<Map<String, String>> items, int levelId, ItemType category) {
    final List<DropZone> zones = [];
    final double spacing = 120.0;
    final double startY = 100.0;
    
    // Always use horizontal layout for drop zones at the top
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final double x = (MediaQueryData.fromView(WidgetsBinding.instance.window).size.width / 2) - 
                      ((items.length - 1) * spacing / 2) + 
                      (i * spacing);
      
      zones.add(DropZone(
        id: 'zone_$i',
        acceptedType: category,
        position: Offset(x, startY),
        color: _itemColors[i % _itemColors.length],
        priority: i,
        label: item['name'],
      ));
    }
    
    return zones;
  }
  
  List<DragItem> _generateItems(List<Map<String, String>> items, int levelId, ItemType category) {
    final List<DragItem> dragItems = [];
    final double spacing = 120.0;
    final double startY = 400.0;
    
    // Create a shuffled list of indices to randomize item order
    final List<int> indices = List.generate(items.length, (i) => i)..shuffle(_random);
    
    // Always use horizontal layout for items at the bottom
    for (int i = 0; i < items.length; i++) {
      final int index = indices[i];
      final item = items[index];
      final double x = (MediaQueryData.fromView(WidgetsBinding.instance.window).size.width / 2) - 
                      ((items.length - 1) * spacing / 2) + 
                      (i * spacing);
      
      dragItems.add(DragItem(
        id: 'item_$index',
        type: category,
        color: _itemColors[index % _itemColors.length],
        position: Offset(x, startY),
        imagePath: item['image'],
        label: item['name'],
      ));
    }
    
    return dragItems;
  }
  
  String _generateDescription(int levelId, ItemType category) {
    return 'Match the ${category.toString().split('.').last.toLowerCase()} images with their names';
  }
  
  Map<String, dynamic> _generateSpecialRules(int levelId) {
    return {};
  }
}