import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/level.dart';
import '../providers/game_provider.dart';
import 'drag_item_widget.dart';
import 'drop_zone_widget.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final Level? level = gameProvider.gameState.currentLevel;
    
    if (level == null) {
      return Center(
        child: Text('No level loaded'),
      );
    }
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100,
            Colors.blue.shade200,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background elements
          _buildBackgroundElements(level),
          
          // Drop zones
          ...level.dropZones.map((zone) => DropZoneWidget(
            zone: zone,
            onItemDropped: (itemId, zoneId) {
              gameProvider.onItemDropped(itemId, zoneId);
            },
            onDragEnter: (zoneId) {
              // Highlight the zone
              final updatedZones = level.dropZones.map((z) {
                if (z.id == zoneId) {
                  return z.copyWith(isHighlighted: true);
                }
                return z;
              }).toList();
              
              level.dropZones.clear();
              level.dropZones.addAll(updatedZones);
            },
            onDragExit: (zoneId) {
              // Remove highlight
              final updatedZones = level.dropZones.map((z) {
                if (z.id == zoneId) {
                  return z.copyWith(isHighlighted: false);
                }
                return z;
              }).toList();
              
              level.dropZones.clear();
              level.dropZones.addAll(updatedZones);
            },
          )),
          
          // Draggable items
          ...level.items.map((item) => DragItemWidget(
            item: item,
            onDragStarted: (itemId) {
              gameProvider.onDragStart(itemId);
            },
            onDragEnded: (itemId) {
              gameProvider.onDragEnd(itemId);
            },
            onDragUpdate: (itemId, offset) {
              // Update item position during drag if needed
            },
          )),
        ],
      ),
    );
  }
  
  Widget _buildBackgroundElements(Level level) {
    return Stack(
      children: [
        // Grid lines
        CustomPaint(
          size: Size.infinite,
          painter: GridPainter(),
        ),
        
        // Level indicator
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level ${level.id}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for grid lines
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 1.0;
    
    const double spacing = 40.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}