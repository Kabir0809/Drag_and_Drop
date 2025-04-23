import 'package:flutter/material.dart';
import 'drag_item.dart';

class DropZone {
  final String id;
  final ItemType acceptedType;
  final Offset position;
  final double size;
  final int priority;
  final Color color;
  String? occupiedBy;
  bool isHighlighted = false;
  String? imagePath;
  String? label;
  String? description;
  bool showHint = false;
  
  DropZone({
    required this.id,
    required this.acceptedType,
    required this.position,
    this.size = 90.0,
    this.priority = 0,
    required this.color,
    this.occupiedBy,
    this.imagePath,
    this.label,
    this.description,
    this.showHint = false,
  });
  
  bool canAccept(DragItem item) {
    if (occupiedBy != null) return false;
    if (item.type != acceptedType) return false;
    return item.label == label;
  }
  
  DropZone copyWith({
    String? id,
    ItemType? acceptedType,
    Offset? position,
    double? size,
    int? priority,
    Color? color,
    String? occupiedBy,
    bool? isHighlighted,
    String? imagePath,
    String? label,
    String? description,
    bool? showHint,
  }) {
    return DropZone(
      id: id ?? this.id,
      acceptedType: acceptedType ?? this.acceptedType,
      position: position ?? this.position,
      size: size ?? this.size,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      occupiedBy: occupiedBy ?? this.occupiedBy,
      imagePath: imagePath ?? this.imagePath,
      label: label ?? this.label,
      description: description ?? this.description,
      showHint: showHint ?? this.showHint,
    )..isHighlighted = isHighlighted ?? this.isHighlighted;
  }
}