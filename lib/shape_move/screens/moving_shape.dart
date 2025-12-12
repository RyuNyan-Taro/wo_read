import 'dart:math';

import 'package:flutter/material.dart';

class MovingShape extends StatefulWidget {
  final Offset position;
  final int id;
  const MovingShape({super.key, required this.position, required this.id});

  @override
  _MovingShapeState createState() => _MovingShapeState();
}

class _MovingShapeState extends State<MovingShape> {
  static const double headerMargin = 80;

  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.position;
  }

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

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: (details) => _onPanUpdate(details, widgetSize, 100, 100),
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
    );
  }
}
