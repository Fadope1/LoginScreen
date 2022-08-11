import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pausable_timer/pausable_timer.dart';

// TODO: change waves => when in second screen paralax scroll

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  static const double waveStartPosY = 600;
  static const double waveStartPosX = -900;

  bool startAnimation = false;
  bool swipeAnimation = false;
  dynamic timer;
  double rate = 0.0;
  bool animationPlaying = true;

  void toogleAnimationPlayer() {
    print("toogle");
    setState(() {
      animationPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();

    timer = PausableTimer(
      const Duration(milliseconds: 2000),
      () => setState(() {
        animationPlaying = true;
        startAnimation = true;
      }),
    );
    timer.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener(
        onNotification: ((notification) {
          if (notification is ScrollUpdateNotification) {
            setState(() {
              rate -= notification.scrollDelta! / 4;
            });
            return true;
          }
          return false;
        }),
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Wave(
              asset: "assets/waves/yellow.svg",
              topOffset: startAnimation ? 370 + rate : waveStartPosY,
              leftOffset: swipeAnimation ? waveStartPosX : 0,
              opacity: startAnimation ? 1 : 0,
              animate: animationPlaying,
              toogleAnimationState: toogleAnimationPlayer,
            ),
            Wave(
              asset: "assets/waves/orange.svg",
              topOffset: startAnimation ? 370 + rate : waveStartPosY,
              leftOffset: swipeAnimation ? waveStartPosX : 0,
              opacity: startAnimation ? 1 : 0,
              animate: animationPlaying,
              toogleAnimationState: toogleAnimationPlayer,
            ),
            Wave(
              asset: "assets/waves/blue.svg",
              topOffset: startAnimation ? 450 + rate : waveStartPosY,
              leftOffset: swipeAnimation ? waveStartPosX : 0,
              opacity: startAnimation ? 1 : 0,
              animate: animationPlaying,
              toogleAnimationState: toogleAnimationPlayer,
            ),
            ListView(
              children: const <Widget>[
                SizedBox(height: 700),
                Divider(),
                Text("this is a text"),
                SizedBox(height: 500),
              ],
            ),
            Positioned(left: 200, top: 200, child: Text('$rate')),
            Positioned(
              top: 100,
              child: TextButton(
                onPressed: () => setState(() {
                  animationPlaying = true;
                  startAnimation = !startAnimation;
                  timer.reset();
                  timer.start();
                }),
                child: Text('$startAnimation'),
              ),
            ),
            Positioned(
              top: 100,
              left: 150,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    animationPlaying = true;
                    swipeAnimation = !swipeAnimation;
                  });
                },
                child: Text('$swipeAnimation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Wave extends StatefulWidget {
  Wave({
    super.key,
    required this.topOffset,
    required this.leftOffset,
    required this.opacity,
    required this.asset,
    required this.toogleAnimationState,
    this.animate = true,
  });

  final Function toogleAnimationState;
  final double topOffset;
  final double leftOffset;
  final double opacity;
  final String asset;
  bool animate;

  @override
  State<Wave> createState() => _WaveState();
}

class _WaveState extends State<Wave> {
  @override
  Widget build(BuildContext context) {
    return widget.animate
        ? AnimatedPositioned(
            onEnd: () {
              widget.toogleAnimationState();
            },
            top: widget.topOffset,
            left: widget.leftOffset,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 1),
            child: AnimatedOpacity(
              opacity: widget.opacity,
              duration: const Duration(milliseconds: 500),
              child: SvgPicture.asset(widget.asset),
            ),
          )
        : Positioned(
            top: widget.topOffset,
            left: widget.leftOffset,
            child: SvgPicture.asset(widget.asset),
          );
  }
}
