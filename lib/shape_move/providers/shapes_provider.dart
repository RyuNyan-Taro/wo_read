import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/moving_shape.dart';

part 'shapes_provider.g.dart';

@riverpod
class Shapes extends _$Shapes {
  @override
  List<MovingShape> build() => [
    MovingShape(position: Offset(0, 0)),
    MovingShape(position: Offset(100, 100)),
    MovingShape(position: Offset(200, 200)),
  ];

  void add(MovingShape value) {
    state = [...state, value];
  }

  void remove(MovingShape value) {
    state = state.where((x) => x != value).toList();
  }

  void clear() {
    state = [];
  }
}
