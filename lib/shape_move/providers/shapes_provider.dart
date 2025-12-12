import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/moving_shape.dart';

part 'shapes_provider.g.dart';

@riverpod
class Shapes extends _$Shapes {
  @override
  List<MovingShape> build() => [
    MovingShape(position: Offset(0, 0), id: 0),
    MovingShape(position: Offset(100, 100), id: 1),
    MovingShape(position: Offset(200, 200), id: 2),
  ];

  void add(MovingShape value) {
    state = [...state, value];
  }

  void remove(MovingShape value) {
    state = state.where((x) => x != value).toList();
  }

  void updatePosition(int id, Offset newPosition) {
    state = [
      for (final shape in state)
        if (shape.id == id)
          MovingShape(position: newPosition, id: shape.id)
        else
          shape,
    ];
  }

  void clear() {
    state = [];
  }

  bool judgeConflict(int myId, Offset modPos) {
    final List<MovingShape> others = [];
    MovingShape myShape = MovingShape(position: Offset(0, 0), id: 0);

    for (MovingShape shape in state) {
      if (shape.id == myId) {
        myShape = shape;
        continue;
      }
      others.add(shape);
    }
    if (others.isEmpty) return false;

    for (MovingShape other in others) {
      if (_isConflicted(myShape, other, modPos)) return true;
    }

    return false;
  }
}

bool _isConflicted(MovingShape myShape, MovingShape other, Offset modPos) {
  if (other.position.dx <= modPos.dx &&
      modPos.dx <= other.position.dx + 100 &&
      other.position.dy <= modPos.dy &&
      modPos.dy <= other.position.dy + 100) {
    print('conflict');
  }
  return false;
}
