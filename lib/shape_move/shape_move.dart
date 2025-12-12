// ref: https://flutter.salon/widget/gesturedetector/#パフォーマンスへの影響

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wo_read/shape_move/providers/shapes_provider.dart';
import 'package:wo_read/shape_move/screens/moving_shape.dart';

class ShapeMovePage extends ConsumerStatefulWidget {
  const ShapeMovePage({super.key});

  @override
  _ShapeMovePageState createState() => _ShapeMovePageState();
}

class _ShapeMovePageState extends ConsumerState<ShapeMovePage> {
  @override
  Widget build(BuildContext context) {
    final List<MovingShape> shapes = ref.watch(shapesProvider);
    print(shapes);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shape move'),
      ),
      body: Stack(children: shapes),
    );
  }
}
