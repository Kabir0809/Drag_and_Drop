import 'dart:math';
import 'drag_item.dart';
import 'drop_zone.dart';

class Level {
  final int id;
  final String name;
  final String description;
  final int timeLimit; // in seconds, 0 means no limit
  final List<DragItem> items;
  final List<DropZone> dropZones;
  final int starThresholds; // points needed for 3 stars
  final Map<String, dynamic> specialRules;
  
  Level({
    required this.id,
    required this.name,
    required this.description,
    this.timeLimit = 0,
    required this.items,
    required this.dropZones,
    required this.starThresholds,
    this.specialRules = const {},
  });
  
  bool get isCompleted {
    // A level is completed when all drop zones are occupied
    return dropZones.every((zone) => zone.occupiedBy != null);
  }
  
  // Calculate score based on time and accuracy
  int calculateScore(int timeRemaining, int moves) {
    int baseScore = dropZones.length * 100;
    int timeBonus = timeLimit > 0 ? timeRemaining * 10 : 0;
    int movesPenalty = max(0, (moves - dropZones.length) * 5);
    
    return baseScore + timeBonus - movesPenalty;
  }
}