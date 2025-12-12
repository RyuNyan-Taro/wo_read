import 'package:flutter/material.dart';
import 'package:wo_read/shape_move/screens/moving_shape.dart';

class Counter extends ChangeNotifier {
  List<MovingShape> shapes = [];

  void addShape(MovingShape shape) {
    shapes.add(shape);
    notifyListeners();
  }
}
