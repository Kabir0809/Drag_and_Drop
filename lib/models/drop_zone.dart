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
  
  DropZone({
    required this.id,
    required this.acceptedType,
    required this.position,
    this.size = 90.0,
    this.priority = 0,
    required this.color,
    this.occupiedBy,
  });
  
  bool canAccept(DragItem item) {
    return item.type == acceptedType && occupiedBy == null;
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
  }) {
    return DropZone(
      id: id ?? this.id,
      acceptedType: acceptedType ?? this.acceptedType,
      position: position ?? this.position,
      size: size ?? this.size,
      priority: priority ?? this.priority,
      color: color ?? this.color,
      occupiedBy: occupiedBy ?? this.occupiedBy,
    )..isHighlighted = isHighlighted ?? this.isHighlighted;
  }
}