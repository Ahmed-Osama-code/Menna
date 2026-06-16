/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vigil/widgets/page_trans.dart';

import 'fogot_password.dart';



class ForgetPasswordEmailPage extends StatefulWidget {
  const ForgetPasswordEmailPage({super.key});

  @override
  State<ForgetPasswordEmailPage> createState() =>
      _ForgetPasswordEmailPageState();
}

class _ForgetPasswordEmailPageState extends State<ForgetPasswordEmailPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const topColor = Color(0xFF64CDC6);
    const bottomColor = Color(0xFF136A88);

    return Scaffold(
      extendBodyBehindAppBar: true, // <<< add this
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        // <<< transparent to show SAME background
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [topColor, bottomColor],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ===== TOP AREA (Back + Logo) =====
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  width: 110,
                                  height: 110,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "MindEase",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ===== WHITE SHEET =====
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                28,
                                30,
                                28,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Forgot Password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Enter your e-mail to receive an OTP code\nso you can create a new password.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 15,
                                      height: 1.25,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  _label("E-mail"),
                                  const SizedBox(height: 10),
                                  _field(
                                    controller: _emailController,
                                    hint: "Enter Your E-mail",
                                    prefix: const Icon(
                                      Icons.mail_outline,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),

                                  const SizedBox(height: 26),

                                  SizedBox(
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final email = _emailController.text.trim();

                                        if (email.isEmpty) {
                                          Get.snackbar(
                                            "Error",
                                            "Please enter your email",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        // Validate email format
                                        if (!email.contains('@')) {
                                          Get.snackbar(
                                            "Error",
                                            "Please enter a valid email",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        try {
                                          // Show loading
                                          Get.dialog(
                                            const Center(child: CircularProgressIndicator()),
                                            barrierDismissible: false,
                                          );

                                          // Call Supabase Edge Function to send OTP
                                          final response = await Supabase.instance.client.functions.invoke(
                                            'send-reset-otp',
                                            body: {
                                              'email': email,
                                            },
                                          );

                                          Get.back(); // Close loading

                                          if (response.status == 200) {
                                            Get.snackbar(
                                              "Success",
                                              "OTP sent to your email",
                                              snackPosition: SnackPosition.BOTTOM,
                                            );

                                            // Navigate to OTP verification screen
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              Navigator.push(
                                                context,
                                                smoothTransition(
                                                  ForgotCreateNewPasswordPage(email: email),
                                                ),
                                              );
                                            });
                                          } else {
                                            Get.snackbar(
                                              "Error",
                                              "Failed to send OTP. Please try again.",
                                              snackPosition: SnackPosition.BOTTOM,
                                            );
                                          }
                                        } catch (error) {
                                          Get.back(); // Close loading
                                          Get.snackbar(
                                            "Error",
                                            "Error: $error",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF136A88,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Send OTP",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,

                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 26),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          "Or",
                                          style: TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          thickness: 1,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialButton(
                                        svgPath: 'assets/images/google.svg',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 26),
                                      _buildSocialButton(
                                        svgPath: 'assets/images/facebook.svg',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 26),
                                      _buildSocialButton(
                                        svgPath: 'assets/images/x.svg',
                                        onTap: () {},
                                      ),
                                    ],
                                  ),

                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF000000),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required Widget prefix,
    Widget? suffix,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 58,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF0E7490), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String svgPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(svgPath, width: 44, height: 44),
    );
  }
}
*/

