import 'package:flutter/material.dart';
import 'package:wo_read/shape_move/screens/moving_shape.dart';

class Counter extends ChangeNotifier {
  List<MovingShape> shapes = [
    MovingShape(position: Offset(0, 0)),
    MovingShape(position: Offset(100, 100)),
    MovingShape(position: Offset(200, 200)),
  ];

  void addShape(MovingShape shape) {
    shapes.add(shape);
    notifyListeners();
  }
}
