// ref: https://flutter.salon/widget/gesturedetector/#パフォーマンスへの影響

import 'package:flutter/material.dart';

class ShapeMovePage extends StatefulWidget {
  const ShapeMovePage({super.key});

  @override
  _ShapeMovePageState createState() => _ShapeMovePageState();
}

class _ShapeMovePageState extends State<ShapeMovePage> {
  Offset position = Offset(0, 0);

  void _onPanUpdate(DragUpdateDetails details, bool isHorizontal) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shape move'),
      ),
      body: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) => _onPanUpdate(details, true),
              onVerticalDragUpdate: (details) => _onPanUpdate(details, false),
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
