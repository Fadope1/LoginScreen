import 'package:flutter/material.dart';

class MagicListPage extends StatelessWidget {
  static const int cardLength = 100;

  const MagicListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Wrap(
          children: List.generate(
            cardLength,
            (index) => const CardItem(),
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatefulWidget {
  const CardItem({super.key});

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          isPressed = !isPressed;
        });
      }),
      child: Card(
        elevation: isPressed ? 50 : 0,
        color: Colors.white,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          padding: isPressed
              ? const EdgeInsets.only(
                  left: 30.0, right: 30.0, top: 20.0, bottom: 20.0)
              : const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
          child: const Text("nice"),
        ),
      ),
    );
  }
}
