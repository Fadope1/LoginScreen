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
    // Offset(66.1, -69.1)
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () => setState(() {
              isPressed = !isPressed;
            }),
            child: Animated3dRotation(
              duration: const Duration(seconds: 1),
              x: isPressed ? -70 : 0,
              y: isPressed ? 66 : 0,
              child: const Card(
                elevation: 20,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("nice"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/**
 GestureDetector(
            onTap: () => setState(() {
              isPressed = !isPressed;
            }),
            child: AnimatedContainer(
              curve: Curves.linearToEaseOut,
              duration: const Duration(milliseconds: 300),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateX(
                  0.01 * (isPressed ? -69.1 : 0),
                )
                ..rotateY(
                  -0.01 * (isPressed ? 66.1 : 0),
                ),
              child: const Card(
                child:
                    Padding(padding: EdgeInsets.all(20), child: Text("Test")),
              ),
            ),
          ),
 */