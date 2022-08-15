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
      onDoubleTap: () => setState(() => _offset = const Offset(0.2, 0.6)),
      child: Scaffold(
        body: Center(
          child: MovableItem(
            _offset,
            child: const Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: Material(elevation: 20, child: Text("This is a test")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MovableItem extends StatelessWidget {
  const MovableItem(this._offset, {super.key, this.child});

  final Offset _offset;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.01)
        ..rotateX(
          0.01 * _offset.dy,
        )
        ..rotateY(
          -0.01 * _offset.dx,
        ),
      child: child ??
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
            ),
          ),
    );
  }
}
