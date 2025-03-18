import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/drop_zone.dart';
import '../models/drag_item.dart';
import '../utils/audio_manager.dart';
import '../utils/haptic_feedback.dart';
import 'dart:math';

class DropZoneWidget extends StatelessWidget {
  final DropZone zone;
  final Function(String, String) onItemDropped;
  final Function(String) onDragEnter;
  final Function(String) onDragExit;
  
  const DropZoneWidget({
    Key? key,
    required this.zone,
    required this.onItemDropped,
    required this.onDragEnter,
    required this.onDragExit,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: zone.position.dx - (zone.size / 2),
      top: zone.position.dy - (zone.size / 2),
      child: DragTarget<String>(
        builder: (context, candidateData, rejectedData) {
          // Determine if there's a valid candidate being dragged over
          final bool hasValidCandidate = candidateData.isNotEmpty;
          
          return _buildZoneShape(
            isHighlighted: zone.isHighlighted || hasValidCandidate,
            isOccupied: zone.occupiedBy != null,
          );
        },
        onWillAccept: (data) {
          if (data != null) {
            onDragEnter(zone.id);
            return true; // Allow any item to be dragged over
          }
          return false;
        },
        onLeave: (data) {
          onDragExit(zone.id);
        },
        onAccept: (itemId) {
          AudioManager().playCorrectDrop();
          HapticFeedbackManager().correctDrop();
          onItemDropped(itemId, zone.id);
        },
      ),
    );
  }
  
  Widget _buildZoneShape({
    required bool isHighlighted,
    required bool isOccupied,
  }) {
    Color zoneColor = zone.color;
    
    if (isHighlighted) {
      zoneColor = zone.color.withOpacity(0.8);
    } else if (isOccupied) {
      zoneColor = zone.color.withOpacity(0.2);
    }
    
    Widget shape;
    
    switch (zone.acceptedType) {
      case ItemType.circle:
        shape = Container(
          width: zone.size,
          height: zone.size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: zoneColor,
              width: 3.0,
            ),
          ),
        );
        break;
      case ItemType.square:
        shape = Container(
          width: zone.size,
          height: zone.size,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: zoneColor,
              width: 3.0,
            ),
          ),
        );
        break;
      case ItemType.triangle:
        shape = CustomPaint(
          size: Size(zone.size, zone.size),
          painter: TriangleOutlinePainter(
            color: zoneColor,
          ),
        );
        break;
      case ItemType.star:
        shape = CustomPaint(
          size: Size(zone.size, zone.size),
          painter: StarOutlinePainter(
            color: zoneColor,
          ),
        );
        break;
    }
    
    // Apply animations and effects
    return shape
      .animate(target: isHighlighted ? 1 : 0)
      .scale(begin: Offset(1.0, 1.0), end: Offset(1.05, 1.05), duration: 200.ms)
      .shimmer(duration: 1000.ms, color: Colors.white.withOpacity(0.3));
  }
}

// Custom painter for triangle outline
class TriangleOutlinePainter extends CustomPainter {
  final Color color;
  
  TriangleOutlinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(TriangleOutlinePainter oldDelegate) => color != oldDelegate.color;
}

// Custom painter for star outline
class StarOutlinePainter extends CustomPainter {
  final Color color;
  
  StarOutlinePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;
    
    final Path path = Path();
    final int numPoints = 5;
    final double innerRadius = radius * 0.4;
    
    for (int i = 0; i < numPoints * 2; i++) {
      final double r = (i % 2 == 0) ? radius : innerRadius;
      final double angle = i * pi / numPoints;
      final double x = centerX + r * cos(angle - pi / 2);
      final double y = centerY + r * sin(angle - pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(StarOutlinePainter oldDelegate) => color != oldDelegate.color;
}