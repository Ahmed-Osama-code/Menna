import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigil/welcome_2.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'package:vigil/widgets/splash2_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _markFirstTimeComplete() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('isFirstTime', false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // general padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () async {
                      await _markFirstTimeComplete();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>  Splash2Screen(),
                          ),
                        );
                      }
                    },
                    child:  Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Person SVG image
                SvgPicture.asset(
                  "assets/images/person1.svg",
                  height: screenHeight * 0.35,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Welcome text
                const Text(
                  "WELCOME",
                  style: TextStyle(
                    color: Color(0xFF136A88),
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Welcome to your personal health companion.\n"
                  " Monitor your vital signs and stay connected with the people who care about you,\n "
                  "all in one simple app.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF090814),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.05),

                // Flower SVG image
                Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    "assets/images/flower.svg",
                    width: screenWidth * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Next button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _markFirstTimeComplete();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          smoothTransition( Welcome2()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape:  RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Next',
                          style: TextStyle(
                            color: Color(0xFF136A88),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/next.svg',
                          width: 18,
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
