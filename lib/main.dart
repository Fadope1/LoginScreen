import 'package:flutter/material.dart';
import 'package:showcase/skill_list.dart';
import 'package:showcase/start_page.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Fabians Showcase app",
        initialRoute: '/',
        routes: {
          '/': (context) => const StartPage(),
          '/skill-list': (context) => const SkillListPage(),
          // '/third': (context) => ThirdScreen(),
        },
      );
}
