// ref: https://flutter.salon/widget/gesturedetector/#パフォーマンスへの影響

import 'package:flutter/material.dart';

class ShapeMovePage extends StatefulWidget {
  const ShapeMovePage({super.key});

  @override
  _ShapeMovePageState createState() => _ShapeMovePageState();
}

class _ShapeMovePageState extends State<ShapeMovePage> {
  Offset position = Offset(0, 0);

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position = Offset(
        position.dx + details.delta.dx,
        position.dy + details.delta.dy,
      );
    });

    print('globalPosition: ${details.globalPosition}');
    print('localPosition: ${details.localPosition}');
    print('delta: ${details.delta}');
    print('primaryDelta: ${details.primaryDelta}');
    print('sourceTimeStamp: ${details.sourceTimeStamp}');
  }

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
            left: position.dx,
            top: position.dy,
            child: GestureDetector(
              onPanUpdate: (details) => _onPanUpdate(details),
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
