import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/drag_item.dart';
import '../utils/audio_manager.dart';
import '../utils/haptic_feedback.dart';
import 'dart:math';

class DragItemWidget extends StatelessWidget {
  final DragItem item;
  final Function(String) onDragStarted;
  final Function(String) onDragEnded;
  final Function(String, Offset) onDragUpdate;
  
  const DragItemWidget({
    Key? key,
    required this.item,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.onDragUpdate,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.position.dx - (item.size / 2),
      top: item.position.dy - (item.size / 2),
      child: Draggable<String>(
        data: item.id,
        feedback: _buildItemContent(opacity: 0.8, elevation: 8.0),
        childWhenDragging: _buildItemContent(opacity: 0.3),
        onDragStarted: () {
          AudioManager().playDragStart();
          HapticFeedbackManager().dragStart();
          onDragStarted(item.id);
        },
        onDragEnd: (details) {
          AudioManager().playDragEnd();
          HapticFeedbackManager().dragEnd();
          onDragEnded(item.id);
        },
        onDragUpdate: (details) {
          onDragUpdate(item.id, details.localPosition);
        },
        child: _buildItemContent(),
      ),
    );
  }
  
  Widget _buildItemContent({double opacity = 1.0, double elevation = 2.0}) {
    return Material(
      color: Colors.transparent,
      elevation: elevation,
      child: Container(
        width: item.size,
        height: item.size,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.color.withOpacity(opacity),
            width: 3.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset(
            item.imagePath!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    )
    .animate(target: item.isDragging ? 1 : 0)
    .scale(
      begin: Offset(1.0, 1.0),
      end: Offset(1.1, 1.1),
      duration: 300.ms,
      curve: Curves.easeOutBack,
    )
    .shimmer(
      duration: 1000.ms,
      color: Colors.white.withOpacity(0.3),
    );
  }
}

// Custom painter for triangle shape
class TrianglePainter extends CustomPainter {
  final Color color;
  
  TrianglePainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final Path path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => color != oldDelegate.color;
}

// Custom painter for star shape
class StarPainter extends CustomPainter {
  final Color color;
  
  StarPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
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
  bool shouldRepaint(StarPainter oldDelegate) => color != oldDelegate.color;
}