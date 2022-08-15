import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:rive/rive.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  bool animationPlaying = true;

  static const double defaultWavePos = 750;
  double rateBlue = defaultWavePos;
  double rateOrange = defaultWavePos + 200;
  double rateYellow = defaultWavePos + 500;

  bool firstRun =
      true; // rather its the first time running the app -> only run certain animations once

  bool animateRight = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      animationPlaying = true;
    });

    PausableTimer(
      const Duration(seconds: 1),
      () => setState(() {
        rateBlue = 430;
        rateOrange = 300;
        rateYellow = 500;
      }),
    ).start();
  }

  @override
  Widget build(BuildContext context) {
    double rightOffset = animateRight ? 0 : -1000;
    double leftOffset = animateRight ? -1000 : 0;
    Size window = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener(
        onNotification: (noti) {
          if (!animationPlaying &&
              animateRight &&
              noti is ScrollUpdateNotification) {
            setState(() {
              rateBlue -= noti.scrollDelta!;
              rateYellow -= noti.scrollDelta! / 1.5;
              rateOrange -= noti.scrollDelta! / 2;
            });
            return true;
          }
          return false;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Wave(
                "assets/waves/orange.svg",
                animate: animationPlaying,
                topOffset: rateOrange,
                rightOffset: rightOffset,
              ),
              Wave(
                "assets/waves/yellow.svg",
                animate: animationPlaying,
                topOffset: rateYellow,
                rightOffset: rightOffset,
              ),
              Wave(
                "assets/waves/blue.svg",
                animate: animationPlaying,
                topOffset: rateBlue,
                rightOffset: rightOffset,
                onAnimationEnd: () => setState(
                  () {
                    animationPlaying = false;
                  },
                ),
              ),
              // this is the right side of the screen
              if (animateRight)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: !animationPlaying && animateRight ? 1 : 0,
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(height: 150),
                      const Center(
                        child: Text(
                          "Successfully logged in!",
                          textScaleFactor: 2,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 550),
                      const Text("this is a text after sized box"),
                      SizedBox(
                        height: 600,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/skill-list');
                          },
                          child: const Text(
                            "Press me",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // this is the left side login widget
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                top: firstRun && animationPlaying ? 700 : window.width / 4,
                curve: Curves.fastOutSlowIn,
                left: leftOffset,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastOutSlowIn,
                  opacity: firstRun && animationPlaying ? 0 : 1,
                  child: SizedBox(
                    width: 300,
                    child: Login(
                      onSuccess: () {
                        setState(() {
                          rateYellow = 360; // only show on right side
                          animationPlaying = true;
                          animateRight = !animateRight;
                          rateBlue = 430;
                          rateOrange = 300;
                          firstRun = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // debug floating action button topleft
              Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: FloatingActionButton(
                    onPressed: () => setState(
                      () {
                        rateYellow = animateRight
                            ? defaultWavePos + 500
                            : 360; // only show on right side
                        animationPlaying = true;
                        animateRight = !animateRight;
                        rateBlue = 430;
                        rateOrange = 300;
                        firstRun = false;
                      },
                    ),
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key, this.onSuccess});

  final Function()? onSuccess;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SMITrigger? _press;
  SMINumber? _loadingPercentage;

  void _inButtonInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _press = controller.findInput<bool>('Pressed') as SMITrigger;
    (controller.findInput<bool>('Hover') as SMIBool).change(true);
    _loadingPercentage = controller.findInput<double>('Loading') as SMINumber;
  }

  SMITrigger? _success;
  SMITrigger? _failure;
  SMIBool? _isChecking;
  SMIBool? _isHiding;
  SMINumber? _mouseLoc;

  void _onTeddyInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'Login Machine');
    artboard.addController(controller!);
    _success = controller.findInput<bool>('trigSuccess') as SMITrigger;
    _failure = controller.findInput<bool>('trigFail') as SMITrigger;
    _isChecking = controller.findInput<bool>('isChecking') as SMIBool;
    _isHiding = controller.findInput<bool>('isHandsUp') as SMIBool;
    _mouseLoc = controller.findInput<double>('numLook') as SMINumber;
  }

  void onSubmit({String? value}) {
    _isHiding!.change(false);

    _press!.fire();

    PausableTimer(
      const Duration(seconds: 1),
      () async {
        // loading logic -> get data from internet etc.
        for (int i in Iterable.generate(101)) {
          _loadingPercentage!.change(i.toDouble());
          await Future.delayed(const Duration(milliseconds: 10));
        }

        value ??= pwdValue;
        // password logic -> check if passwort/ email is correct
        if (value == "123" && emailValue == "abc@abc.com") {
          _success!.fire();
          PausableTimer(const Duration(milliseconds: 800), () {
            if (widget.onSuccess != null) {
              widget.onSuccess!();
            }
          }).start();
        } else {
          _failure!.fire();
        }
        _isHiding!
            .change(isTypingPWD); // change back to hiding if still focused
      },
    ).start();
  }

  @override
  void initState() {
    super.initState();

    _focus.addListener(_onFocusChange);
  }

  String emailValue = "";
  String pwdValue = "";
  bool isTypingPWD = false;
  final FocusNode _focus = FocusNode();

  void _onFocusChange() => setState(() {
        setState(() {
          isTypingPWD = !isTypingPWD;
        });

        _isHiding!.change(isTypingPWD);
      });

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: 250,
          child: Stack(
            children: [
              RiveAnimation.asset(
                'assets/riv/teddy_login_animation.riv',
                fit: BoxFit.cover,
                onInit: _onTeddyInit,
              ),
              Positioned(
                top: 90,
                left: 50,
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    // email textfield
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 15),
                      border: InputBorder.none,
                    ),
                    obscureText: false,
                    autocorrect: false,
                    // focusNode: _focus,
                    onChanged: (value) => setState(
                      () {
                        setState(() {
                          emailValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                left: 50,
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    // pwd textfield
                    style: const TextStyle(fontSize: 20),
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 15),
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                    autocorrect: false,
                    focusNode: _focus,
                    onChanged: (value) => setState(
                      () {
                        setState(() {
                          pwdValue = value;
                        });
                      },
                    ),
                    onSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      onSubmit(value: value);
                    },
                    // onEditingComplete: onSubmit,
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            onSubmit();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 50,
              width: 50,
              child: RiveAnimation.asset(
                'assets/riv/download_icon.riv',
                fit: BoxFit.cover,
                onInit: _inButtonInit,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Wave widget for displaying animated svg waves
class Wave extends StatelessWidget {
  const Wave(
    this.asset, {
    super.key,
    this.animate = false,
    this.onAnimationEnd,
    this.opacity = 1,
    this.topOffset = 0,
    this.rightOffset = 0,
  });

  final String asset;
  final bool animate;
  final Function? onAnimationEnd;
  final double opacity;
  final double topOffset;
  final double rightOffset;

  void onEnd() => WidgetsBinding.instance.addPostFrameCallback(
        (_) => onAnimationEnd!(),
      );

  @override
  Widget build(BuildContext context) {
    Widget wave = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 500),
      child: SvgPicture.asset(asset),
    );

    return AnimatedPositioned(
      duration: Duration(seconds: animate ? 1 : 0),
      curve: Curves.fastOutSlowIn,
      top: topOffset,
      right: rightOffset,
      onEnd: onAnimationEnd == null ? () {} : onEnd,
      child: wave,
    );
  }
}
