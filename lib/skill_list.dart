import 'package:flutter/material.dart';

class SkillListPage extends StatelessWidget {
  const SkillListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Press me to go back"),
      ),
    );
  }
}
