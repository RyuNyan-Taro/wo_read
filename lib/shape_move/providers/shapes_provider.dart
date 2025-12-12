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
    final List<MovingShape> others = state
        .where((shape) => shape.id != myId)
        .toList();

    for (MovingShape other in others) {
      if (_isConflicted(other, modPos)) return true;
    }

    return false;
  }

  bool judgeAnyConflict(Offset myBox) {
    for (MovingShape shape in state) {
      if (_isConflicted(shape, myBox)) return true;
    }
    return false;
  }
}

bool _isConflicted(MovingShape other, Offset modPos) {
  final List<Offset> edgePositions = [
    modPos,
    Offset(modPos.dx, modPos.dy + 100),
    Offset(modPos.dx + 100, modPos.dy),
    Offset(modPos.dx + 100, modPos.dy + 100),
  ];

  for (Offset edge in edgePositions) {
    if (other.position.dx <= edge.dx &&
        edge.dx <= other.position.dx + 100 &&
        other.position.dy <= edge.dy &&
        edge.dy <= other.position.dy + 100) {
      return true;
    }
  }

  return false;
}
