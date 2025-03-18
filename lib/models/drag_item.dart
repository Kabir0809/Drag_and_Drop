import 'package:flutter/material.dart';

enum ItemType { circle, square, triangle, star }

class DragItem {
  final String id;
  final ItemType type;
  final Color color;
  final double size;
  final Map<String, dynamic> properties;
  bool isDragging = false;
  Offset position;
  
  DragItem({
    required this.id,
    required this.type,
    required this.color,
    this.size = 80.0,
    this.properties = const {},
    this.position = Offset.zero,
  });
  
  DragItem copyWith({
    String? id,
    ItemType? type,
    Color? color,
    double? size,
    Map<String, dynamic>? properties,
    bool? isDragging,
    Offset? position,
  }) {
    return DragItem(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      size: size ?? this.size,
      properties: properties ?? this.properties,
      position: position ?? this.position,
    )..isDragging = isDragging ?? this.isDragging;
  }
}