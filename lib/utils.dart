import 'package:flutter/material.dart';

class TestTransform extends StatefulWidget {
  const TestTransform({super.key});

  @override
  State<TestTransform> createState() => _TestTransformState();
}

class _TestTransformState extends State<TestTransform> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () => setState(() {
              isPressed = !isPressed;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateX(
                  0.01 * (isPressed ? 0 : 0),
                )
                ..rotateY(
                  -0.01 * (isPressed ? 30 : 0),
                ),
              child: const Card(
                child:
                    Padding(padding: EdgeInsets.all(20), child: Text("Test")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
