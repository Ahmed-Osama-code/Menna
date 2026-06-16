import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'package:vigil/widgets/user_login.dart';

class PasswordUpdatedSuccessPage extends StatelessWidget {
  const PasswordUpdatedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    const topColor = Color(0xFF64CDC6);
    const bottomColor = Color(0xFF136A88);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [topColor, bottomColor],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const Spacer(flex: 6),

                // Badge + check
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Image.asset("assets/images/iconissuccess.png"),
                ),

                const SizedBox(height: 26),

                const Text(
                  "Password Updated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Your Password has been\nsuccessfully updated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),

                const Spacer(flex: 5),

                SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Back to login/root
                      Navigator.push(context, smoothTransition(UserLogin()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
