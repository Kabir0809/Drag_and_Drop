import 'dart:math';
import 'package:flutter/material.dart';
import '../models/level.dart';
import '../models/drag_item.dart';
import '../models/drop_zone.dart';

class LevelGenerator {
  final Random _random = Random();
  
  // Color palette for items and zones
  final List<Color> _itemColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
  ];
  
  // Generate a level based on level ID
  Level generateLevel(int levelId) {
    // Adjust difficulty based on level ID
    final int itemCount = min(3 + levelId, 10);
    final bool useTimer = levelId > 2;
    final int timeLimit = useTimer ? 60 + (levelId * 10) : 0;
    
    // Generate drop zones
    final List<DropZone> dropZones = _generateDropZones(itemCount, levelId);
    
    // Generate draggable items
    final List<DragItem> items = _generateItems(dropZones, levelId);
    
    // Determine star thresholds based on difficulty
    final int starThresholds = itemCount * 100;
    
    return Level(
      id: levelId,
      name: 'Level $levelId',
      description: _generateDescription(levelId),
      timeLimit: timeLimit,
      items: items,
      dropZones: dropZones,
      starThresholds: starThresholds,
      specialRules: _generateSpecialRules(levelId),
    );
  }
  
  // Generate drop zones for the level
  List<DropZone> _generateDropZones(int count, int levelId) {
    final List<DropZone> zones = [];
    final double spacing = 100.0;
    
    // Determine layout pattern based on level
    if (levelId % 3 == 0) {
      // Circular pattern
      for (int i = 0; i < count; i++) {
        final double angle = 2 * pi * i / count;
        final double radius = 120.0;
        final double x = 200 + radius * cos(angle);
        final double y = 300 + radius * sin(angle);
        
        zones.add(DropZone(
          id: 'zone_$i',
          acceptedType: _getItemTypeForIndex(i),
          position: Offset(x, y),
          color: _itemColors[i % _itemColors.length].withOpacity(0.3),
          priority: i,
        ));
      }
    } else if (levelId % 3 == 1) {
      // Grid pattern
      final int cols = sqrt(count).ceil();
      final int rows = (count / cols).ceil();
      
      for (int i = 0; i < count; i++) {
        final int row = i ~/ cols;
        final int col = i % cols;
        final double x = 100 + col * spacing;
        final double y = 200 + row * spacing;
        
        zones.add(DropZone(
          id: 'zone_$i',
          acceptedType: _getItemTypeForIndex(i),
          position: Offset(x, y),
          color: _itemColors[i % _itemColors.length].withOpacity(0.3),
          priority: i,
        ));
      }
    } else {
      // Random pattern
      for (int i = 0; i < count; i++) {
        final double x = 100 + _random.nextDouble() * 200;
        final double y = 200 + _random.nextDouble() * 300;
        
        zones.add(DropZone(
          id: 'zone_$i',
          acceptedType: _getItemTypeForIndex(i),
          position: Offset(x, y),
          color: _itemColors[i % _itemColors.length].withOpacity(0.3),
          priority: i,
        ));
      }
    }
    
    return zones;
  }
  
  // Generate draggable items for the level
  List<DragItem> _generateItems(List<DropZone> zones, int levelId) {
    final List<DragItem> items = [];
    final double startY = 500.0;
    final double spacing = 100.0;
    
    // Create a shuffled list of indices to randomize item order
    final List<int> indices = List.generate(zones.length, (i) => i);
    indices.shuffle();
    
    for (int i = 0; i < zones.length; i++) {
      final int index = indices[i];
      final DropZone zone = zones[index];
      
      items.add(DragItem(
        id: 'item_$i',
        type: zone.acceptedType,
        color: _itemColors[index % _itemColors.length],
        position: Offset(50 + i * spacing, startY),
      ));
    }
    
    return items;
  }
  
  // Get item type based on index
  ItemType _getItemTypeForIndex(int index) {
    switch (index % 4) {
      case 0:
        return ItemType.circle;
      case 1:
        return ItemType.square;
      case 2:
        return ItemType.triangle;
      case 3:
        return ItemType.star;
      default:
        return ItemType.circle;
    }
  }
  
  // Generate level description
  String _generateDescription(int levelId) {
    final List<String> descriptions = [
      'Match the shapes to their correct positions.',
      'Arrange the items in their designated spots.',
      'Complete the pattern by dragging items to matching zones.',
      'Test your speed and accuracy in this challenging puzzle.',
      'Can you solve this puzzle before time runs out?',
    ];
    
    return descriptions[levelId % descriptions.length];
  }
  
  // Generate special rules based on level ID
  Map<String, dynamic> _generateSpecialRules(int levelId) {
    final Map<String, dynamic> rules = {};
    
    // Add special rules for higher levels
    if (levelId > 5) {
      rules['movingTargets'] = true;
    }
    
    if (levelId > 8) {
      rules['itemTransformation'] = true;
    }
    
    return rules;
  }
}