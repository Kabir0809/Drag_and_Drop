import 'package:flutter/material.dart';

enum ItemType {
  animal,
  number,
  landmark,
  sport,
  vehicle,
  furniture,
  food,
  instrument,
  clothing,
  weather,
  shape,
  color,
  job,
  season,
  emotion,
}

class DragItem {
  final String id;
  final ItemType type;
  final Color color;
  final double size;
  bool isDragging = false;
  Offset position;
  String? imagePath;
  String? label;
  
  DragItem({
    required this.id,
    required this.type,
    required this.color,
    this.size = 80.0,
    this.position = Offset.zero,
    this.imagePath,
    this.label,
  });
  
  DragItem copyWith({
    String? id,
    ItemType? type,
    Color? color,
    double? size,
    bool? isDragging,
    Offset? position,
    String? imagePath,
    String? label,
  }) {
    return DragItem(
      id: id ?? this.id,
      type: type ?? this.type,
      color: color ?? this.color,
      size: size ?? this.size,
      position: position ?? this.position,
      imagePath: imagePath ?? this.imagePath,
      label: label ?? this.label,
    )..isDragging = isDragging ?? this.isDragging;
  }
}