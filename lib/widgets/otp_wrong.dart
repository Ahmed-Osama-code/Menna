import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'otp_verf.dart' show OtpVerificationPage;

class OtpWrongPage extends StatefulWidget {
  final String email;
  final String otp;
  final String? newPassword;

  const OtpWrongPage({
    super.key,
    required this.email,
    required this.otp,
    this.newPassword,
  });

  @override
  State<OtpWrongPage> createState() => _OtpWrongPageState();
}

class _OtpWrongPageState extends State<OtpWrongPage> {
  Future<void> _resendOtp() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Resend OTP
      await Supabase.instance.client.auth.signInWithOtp(
        email: widget.email,
        emailRedirectTo: 'io.supabase.flutter://reset-password/',
      );

      Get.back(); // Close loading

      Get.snackbar(
        "Success",
        "New OTP sent to your email",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to OTP verification page
      Future.delayed(
        const Duration(milliseconds: 500),
            () {
          Get.to(
                () => OtpVerificationPage(
              email: widget.email.trim(),
              newPassword: widget.newPassword,
            ),
          );
        },
      );
    } on AuthException catch (error) {
      Get.back();
      Get.snackbar(
        "Error",
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.back();
      Get.snackbar(
        "Error",
        "Error: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const topColor = Color(0xFF64CDC6);
    const bottomColor = Color(0xFF136A88);

    // Convert OTP string to 6 digits (padded with spaces)
    final digits = widget.otp.padRight(6).split('').take(6).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [topColor, bottomColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SvgPicture.asset(
                  "assets/images/Illustration.svg",
                  height: 360,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 18),
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
                    padding: const EdgeInsets.fromLTRB(26, 34, 26, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE33629),
                                  width: 3,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "!",
                                  style: TextStyle(
                                    color: Color(0xFFE33629),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Text(
                              "OOPSS",
                              style: TextStyle(
                                color: Color(0xFFE33629),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          "Invalid Entered OTP.\nTry again OR Generate new OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.25,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 6 OTP boxes showing entered digits
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _RedOtpBox(digits[0]),
                            _RedOtpBox(digits[1]),
                            _RedOtpBox(digits[2]),
                            _RedOtpBox(digits[3]),
                            _RedOtpBox(digits[4]),
                            _RedOtpBox(digits[5]),
                          ],
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () => Get.back(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE6E6E6),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "Try Again",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 30),
                            Expanded(
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: _resendOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF136A88),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    "New OTP",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
  }
}

class _RedOtpBox extends StatelessWidget {
  final String digit;

  const _RedOtpBox(this.digit);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE53935), width: 2.6),
      ),
      child: Text(
        digit.isEmpty || digit == " " ? "" : digit,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFFE53935),
        ),
      ),
    );
  }
}
