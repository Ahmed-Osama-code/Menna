import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigil/start_screen.dart';
import 'package:vigil/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.isFirstTime});

  final bool isFirstTime;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _rotationController;

  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();

    /// 🔁 Background animation (3 color states)
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _color1 = TweenSequence<Color?>([
      TweenSequenceItem(
        tween:  ColorTween(
          begin:  const Color(0xFF6ECED9), // blue
          end: const Color(0xFFE5C8FF), // purple
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color(0xFFE5C8FF),
          end: const Color(0xFFFFFFFF), // white
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: const Color(0xFFFFFFFF),
          end: const Color(0xFF6ECED9),
        ),
        weight: 1,
      ),
    ]).animate(_bgController);

    _color2 = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin:  Color(0xFFFFFFFF),
          end:  Color(0xFF6ECED9),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin:  Color(0xFF6ECED9),
          end:  Color(0xFFE5C8FF),
        ),

        weight: 1,
      ),
      TweenSequenceItem(
        tween:  ColorTween(
          begin:   Color(0xFFE5C8FF),
          end:     Color(0xFFFFFFFF),
        ),
        weight: 1,
      ),
    ]).animate(_bgController);

    /// 🔄 Logo rotation
    _rotationController = AnimationController(
      vsync: this,
      duration:  const Duration(seconds: 6),
    )..repeat();

    /// ⏭ Navigation - ✅ ONLY CHANGE:  Add isFirstTime logic
    Timer(const Duration(seconds:  4), () {
      if (widget.isFirstTime) {
        // First time → WelcomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>  WelcomeScreen()),
        );
      } else {
        // Second time → StartScreen
        Navigator. pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>  StartScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  AnimatedBuilder(
        animation:  _bgController,
        builder:  (_, __) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin:  Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_color1.value!, _color2.value! ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// LOGO
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // static behind
                        width: 273,
                        height: 191,
                      ),

                      RotationTransition(
                        turns: _rotationController,
                        child: Image.asset(
                          'assets/images/demo.png', // rotating in front
                          width: 108,
                          height: 108,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// APP NAME
                  const Text(
                    'MindEase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight. w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}