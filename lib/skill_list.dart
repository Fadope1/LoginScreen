import 'package:flutter/material.dart';

class SkillListPage extends StatefulWidget {
  const SkillListPage({super.key});

  @override
  State<SkillListPage> createState() => _SkillListPageState();
}

class _SkillListPageState extends State<SkillListPage> {
  double searchBarPosTop = 10.0;
  // double searchBarWidth = 50.0;

  List<Widget> items = List.generate(
    100,
    (index) => Text('List item at place: $index'),
  );

  @override
  Widget build(BuildContext context) {
    // Size window = MediaQuery.of(context).size;

    return CustomScaffold(
      seachBar: const TextField(),
      seachBarTop: searchBarPosTop,
      searchBarWidth: (searchBarPosTop * 5).clamp(200, 300),
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            double deltaY = notification.dragDetails?.delta.dy ?? 0.0;

            double newPos = searchBarPosTop + deltaY;
            newPos = newPos.clamp(10, 90);

            setState(() {
              searchBarPosTop = newPos;
            });

            return true;
          }
          return false;
        },
        child: ListView(
          children: items,
        ),
      ),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    required this.seachBar,
    required this.seachBarTop,
    this.appBarHeight = 75,
    this.searchBarWidth = 100,
  });

  final Widget body;
  final Widget seachBar;
  final double appBarHeight;
  final double seachBarTop;
  final double searchBarWidth;

  @override
  Widget build(BuildContext context) {
    Size window = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(height: appBarHeight, color: Colors.blue),
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: body,
                  ),
                ),
              ],
            ),
            Positioned(
              top: seachBarTop,
              // extract to local var so its only calc once -> check if window size changed
              left: (window.width - searchBarWidth) / 2,
              child: SizedBox(
                width: searchBarWidth,
                height: 50,
                child: Container(color: Colors.green, child: seachBar),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
