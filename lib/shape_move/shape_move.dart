// ref: https://flutter.salon/widget/gesturedetector/#パフォーマンスへの影響

import 'package:flutter/material.dart';
import 'package:wo_read/shape_move/screens/moving_shape.dart';

class ShapeMovePage extends StatefulWidget {
  const ShapeMovePage({super.key});

  @override
  _ShapeMovePageState createState() => _ShapeMovePageState();
}

class _ShapeMovePageState extends State<ShapeMovePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shape move'),
      ),
      body: Stack(
        children: [
          MovingShape(position: Offset(0, 0)),
          MovingShape(position: Offset(100, 100)),
          MovingShape(position: Offset(200, 200)),
        ],
      ),
    );
  }
}
