import 'package:flutter/material.dart';

class TestTransform extends StatefulWidget {
  const TestTransform({super.key});

  @override
  State<TestTransform> createState() => _TestTransformState();
}

class _TestTransformState extends State<TestTransform> {
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: 
              AnimatedTransform(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.01)
                  ..rotateX(
                    0.01 * value,
                  )
                  ..rotateY(
                    -0.01 * value,
                  ),
                child: const Card(
                  child:
                      Padding(padding: EdgeInsets.all(20), child: Text("Test")),
                ),
              ),
        ),
      ),
    );
  }
}

/**

class AnimatedTransform extends ImplicitlyAnimatedWidget {
  const AnimatedTransform({
    Key? key,
    required this.child,
    required this.transform,
    required Duration duration,
    Curve curve = Curves.linear,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final Widget child;
  final Matrix4 transform;

  @override
  AnimatedWidgetBaseState<AnimatedTransform> createState() =>
      _AnimatedTransformState();
}

class _AnimatedTransformState
    extends AnimatedWidgetBaseState<AnimatedTransform> {
  Matrix4Tween? _transform;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: _transform!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _transform = visitor(_transform, widget.transform,
            (dynamic value) => Matrix4Tween(begin: value as Matrix4))
        as Matrix4Tween?;
  }
}

 */