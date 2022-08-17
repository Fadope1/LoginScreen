import 'package:flutter/material.dart';

class MagicPage extends StatefulWidget {
  const MagicPage({super.key});

  @override
  State<MagicPage> createState() => _MagicPageState();
}

class _MagicPageState extends State<MagicPage> {
  Offset _offset = const Offset(.2, .6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => setState(() => _offset += details.delta),
      onDoubleTap: () =>
          setState(() => _offset = const Offset(.2, .6)), // reset rotation
      child: Scaffold(
        body: Center(
          child: MovableItem(
            _offset,
            background: const Card(
              elevation: 15,
              margin: EdgeInsets.all(50),
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Material(elevation: 20),
              ),
            ),
            child: const Text("Test"),
          ),
        ),
      ),
    );
  }
}

class MovableItem extends StatelessWidget {
  const MovableItem(this._offset,
      {super.key, required this.child, this.background});

  final Offset _offset;
  final Widget child;
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    // make this a stack with background and child seperated 3d effect
    Offset offset =
        Offset(_offset.dx.clamp(-100, 100), _offset.dy.clamp(-100, 100));

    Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.01)
      ..rotateX(
        0.01 * offset.dy,
      )
      ..rotateY(
        -0.01 * offset.dx,
      );

    // print(transform);
    // print(offset);

    return Stack(
      children: [
        Transform(
          alignment: FractionalOffset.center,
          transform: transform,
          child: background ??
              const Card(child: Padding(padding: EdgeInsets.all(20))),
        ),
        Positioned(
          // start position needs to be calculated
          left: (85 + _offset.dx / 2).clamp(20, 140),
          top: (85 + _offset.dy / 2).clamp(20, 140),
          // left: 55 + offset.dx,
          // top: 60 + offset.dy,
          child: Transform(
            alignment: FractionalOffset.center,
            transform: transform,
            child: child,
          ),
        ),
      ],
    );
  }
}
