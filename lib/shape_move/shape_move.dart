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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Shape move'),
      ),
      body: Stack(children: [_addBox(ref), ...shapes]),
    );
  }
}

Widget _addBox(WidgetRef ref) {
  return Positioned(
    left: 0,
    top: 0,
    child: InkWell(
      onTap: () => {
        if (ref.read(shapesProvider.notifier).judgeAnyConflict(Offset(0, 0)))
          {print('conflict')}
        else
          {print('tapped')},
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      ),
    ),
  );
}
