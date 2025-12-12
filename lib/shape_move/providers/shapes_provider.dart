import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/moving_shape.dart';

part 'shapes_provider.g.dart';

@riverpod
class Shapes extends _$Shapes {
  @override
  List<MovingShape> build() => [
    MovingShape(
      position: Offset(0, 0),
      id: 0,
      icon: _getRandomIconData(),
      iconColor: _getRandomColor(),
      shapeColor: _getRandomColor(),
    ),
    MovingShape(
      position: Offset(100, 100),
      id: 1,
      icon: _getRandomIconData(),
      iconColor: _getRandomColor(),
      shapeColor: _getRandomColor(),
    ),
    MovingShape(
      position: Offset(200, 200),
      id: 2,
      icon: _getRandomIconData(),
      iconColor: _getRandomColor(),
      shapeColor: _getRandomColor(),
    ),
  ];

  void add() {
    final int lastId = state[state.length - 1].id;
    state = [
      ...state,
      MovingShape(
        position: Offset(0, 0),
        id: lastId + 1,
        icon: _getRandomIconData(),
        iconColor: _getRandomColor(),
        shapeColor: _getRandomColor(),
      ),
    ];
  }

  void remove(MovingShape value) {
    state = state.where((x) => x != value).toList();
  }

  void updatePosition(int id, Offset newPosition) {
    state = [
      for (final shape in state)
        if (shape.id == id)
          MovingShape(
            position: newPosition,
            id: shape.id,
            icon: shape.icon,
            iconColor: shape.iconColor,
            shapeColor: shape.shapeColor,
          )
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

IconData _getRandomIconData() {
  final Random random = Random();
  final int minCodePoint = 0xe000;
  final int maxCodePoint = 0xf8ff;
  final int randomCodePoint =
      minCodePoint + random.nextInt(maxCodePoint - minCodePoint);
  return IconData(randomCodePoint, fontFamily: 'MaterialIcons');
}

Color _getRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}
