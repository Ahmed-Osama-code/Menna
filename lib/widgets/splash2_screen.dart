import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vigil/start_screen.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'package:vigil/widgets/user_login.dart';

class Splash2Screen extends StatefulWidget {
  const Splash2Screen({super.key});

  @override
  State<Splash2Screen> createState() => _Splash2ScreenState();
}

class _Splash2ScreenState extends State<Splash2Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // 👈 animation duration
    );

    _logoScale = Tween<double>(
      begin: 0.6, // small
      end: 1.0, // big
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, smoothTransition(StartScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔹 LOGO (small → big)
            ScaleTransition(
              scale: _logoScale,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo1.svg', // 👈 PUT YOUR LOGO HERE
                    width: 120,
                    height: 80,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "MindEase",
                    style: TextStyle(
                      color: Color(0xFF136A88),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Circular progress
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
