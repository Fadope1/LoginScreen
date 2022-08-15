import 'package:flutter/material.dart';
import 'package:showcase/skill_list.dart';
import 'package:showcase/start_page.dart';

import '3dCardEffectPage.dart';
import '3dListEffectPage.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Fabians Showcase app",
        initialRoute: '/magic/card',
        routes: {
          '/login': (context) => const StartPage(),
          '/skill-list': (context) => const SkillListPage(),
          '/magic/list': (context) => const MagicListPage(),
          '/magic/card': (context) => const MagicPage(),
        },
      );
}
