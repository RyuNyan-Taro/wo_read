// ref: https://flutter.salon/widget/gesturedetector/#パフォーマンスへの影響

import 'dart:math';

import 'package:flutter/material.dart';

class ShapeMovePage extends StatefulWidget {
  const ShapeMovePage({super.key});

  @override
  _ShapeMovePageState createState() => _ShapeMovePageState();
}

class _ShapeMovePageState extends State<ShapeMovePage> {
  Offset position = Offset(0, 0);
  static const double headerMargin = 80;

  void _onPanUpdate(
    DragUpdateDetails details,
    Size widgetSize,
    double shapeWidth,
    shapeHeight,
  ) {
    final double xPos = max(0, position.dx + details.delta.dx);
    final double yPos = max(0, position.dy + details.delta.dy);

    setState(() {
      position = Offset(
        xPos + shapeWidth <= widgetSize.width ? xPos : position.dx,
        yPos + shapeHeight + headerMargin <= widgetSize.height
            ? yPos
            : position.dy,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size widgetSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shape move'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) =>
                  _onPanUpdate(details, widgetSize, 100, 100),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Drag me',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
