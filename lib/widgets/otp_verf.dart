import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vigil/widgets/pass_updated.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'otp_wrong.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String? newPassword; // Optional - for password reset flow

  const OtpVerificationPage({super.key, required this.email, this.newPassword});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // 6 OTP fields
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();
  final _c5 = TextEditingController();
  final _c6 = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();
  final _f4 = FocusNode();
  final _f5 = FocusNode();
  final _f6 = FocusNode();

  final _k1 = FocusNode();
  final _k2 = FocusNode();
  final _k3 = FocusNode();
  final _k4 = FocusNode();
  final _k5 = FocusNode();
  final _k6 = FocusNode();

  String get _otp =>
      "${_c1.text}${_c2.text}${_c3.text}${_c4.text}${_c5.text}${_c6.text}";

  @override
  void dispose() {
    _c1.dispose();
    _c2.dispose();
    _c3.dispose();
    _c4.dispose();
    _c5.dispose();
    _c6.dispose();

    _f1.dispose();
    _f2.dispose();
    _f3.dispose();
    _f4.dispose();
    _f5.dispose();
    _f6.dispose();

    _k1.dispose();
    _k2.dispose();
    _k3.dispose();
    _k4.dispose();
    _k5.dispose();
    _k6.dispose();

    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) {
      Get.snackbar(
        "Invalid Code",
        "Please enter the 6-digit code.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Verify OTP using Supabase Auth
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: _otp,
        type: OtpType.email,
      );

      Get.back(); // Close loading

      if (response.user != null) {
        // OTP verified successfully
        Get.snackbar(
          "Success",
          "OTP verified successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );

        // If newPassword is provided, update the password
        if (widget.newPassword != null && widget.newPassword!.isNotEmpty) {
          try {
            Get.dialog(
              const Center(child: CircularProgressIndicator()),
              barrierDismissible: false,
            );

            // Update password using the updateUser method
            await Supabase.instance.client.auth.updateUser(
              UserAttributes(password: widget.newPassword),
            );

            Get.back(); // Close loading

            Get.snackbar(
              "Success",
              "Password updated successfully!",
              snackPosition: SnackPosition.BOTTOM,
            );

            Future.delayed(const Duration(milliseconds: 500), () {
              Navigator.pushAndRemoveUntil(
                context,
                smoothTransition(PasswordUpdatedSuccessPage()),
                (route) => false,
              );
            });
          } catch (error) {
            Get.back();
            Get.snackbar(
              "Error",
              "Failed to update password: $error",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          // Just OTP verification (sign-up flow)
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushAndRemoveUntil(
              context,
              smoothTransition(PasswordUpdatedSuccessPage()),
              (route) => false,
            );
          });
        }
      }
    } on AuthException catch (error) {
      Get.back();

      // ✅ CHECK IF OTP IS INVALID/WRONG
      if (error.message.contains("Invalid OTP") ||
          error.message.contains("invalid") ||
          error.message.contains("expired")) {
        // Navigate to OtpWrongPage
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.to(
            () => OtpWrongPage(
              email: widget.email,
              otp: _otp,
              newPassword: widget.newPassword,
            ),
          );
        });
      } else {
        Get.snackbar(
          "Verification Failed",
          error.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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
                              padding: const EdgeInsets.fromLTRB(
                                26,
                                34,
                                26,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "Verification",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 22,
                                        height: 1.25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      children: [
                                        const TextSpan(
                                          style: TextStyle(fontSize: 16),
                                          text:
                                              "We Sent a 6 digits verification code to your e-mail\n",
                                        ),
                                        TextSpan(
                                          text: widget.email,
                                          style: const TextStyle(
                                            color: Color(0xFF136A88),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const TextSpan(
                                          style: TextStyle(fontSize: 16),
                                          text: " . you can check your inbox.",
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 34),

                                  // 6 OTP boxes
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _otpBox(
                                        controller: _c1,
                                        focusNode: _f1,
                                        keyFocusNode: _k1,
                                        nextFocus: _f2,
                                        prevFocus: null,
                                        prevController: null,
                                      ),
                                      _otpBox(
                                        controller: _c2,
                                        focusNode: _f2,
                                        keyFocusNode: _k2,
                                        nextFocus: _f3,
                                        prevFocus: _f1,
                                        prevController: _c1,
                                      ),
                                      _otpBox(
                                        controller: _c3,
                                        focusNode: _f3,
                                        keyFocusNode: _k3,
                                        nextFocus: _f4,
                                        prevFocus: _f2,
                                        prevController: _c2,
                                      ),
                                      _otpBox(
                                        controller: _c4,
                                        focusNode: _f4,
                                        keyFocusNode: _k4,
                                        nextFocus: _f5,
                                        prevFocus: _f3,
                                        prevController: _c3,
                                      ),
                                      _otpBox(
                                        controller: _c5,
                                        focusNode: _f5,
                                        keyFocusNode: _k5,
                                        nextFocus: _f6,
                                        prevFocus: _f4,
                                        prevController: _c4,
                                      ),
                                      _otpBox(
                                        controller: _c6,
                                        focusNode: _f6,
                                        keyFocusNode: _k6,
                                        nextFocus: null,
                                        prevFocus: _f5,
                                        prevController: _c5,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 36),

                                  Center(
                                    child: GestureDetector(
                                      onTap: _resendOtp,
                                      child: const Text(
                                        "I didn't receive the code ? Send Again",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  SizedBox(
                                    height: 70,
                                    child: ElevatedButton(
                                      onPressed: _verifyOtp,
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(
                                          double.infinity,
                                          45,
                                        ),
                                        backgroundColor: const Color(
                                          0xFF136A88,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        "Verify",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
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

  Widget _otpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode keyFocusNode,
    required FocusNode? nextFocus,
    required FocusNode? prevFocus,
    required TextEditingController? prevController,
  }) {
    return SizedBox(
      width: 55,
      height: 70,
      child: RawKeyboardListener(
        focusNode: keyFocusNode,
        onKey: (event) {
          if (event is! RawKeyDownEvent) return;

          final isBackspace = event.logicalKey == LogicalKeyboardKey.backspace;

          if (!isBackspace) return;

          if (controller.text.isEmpty && prevFocus != null) {
            prevFocus.requestFocus();
            if (prevController != null) {
              prevController.text = "";
              prevController.selection = const TextSelection.collapsed(
                offset: 0,
              );
            }
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onTap: () {
            if (!keyFocusNode.hasFocus) keyFocusNode.requestFocus();
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: Color(0xFF555555),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: Color(0xFF0E7490),
                width: 2.6,
              ),
            ),
          ),
          onChanged: (v) {
            if (v.isNotEmpty) {
              if (nextFocus != null) {
                nextFocus.requestFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            } else {
              if (prevFocus != null) {
                prevFocus.requestFocus();
              }
            }
          },
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }

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
        "OTP resent to your email",
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear OTP fields
      _c1.clear();
      _c2.clear();
      _c3.clear();
      _c4.clear();
      _c5.clear();
      _c6.clear();
      _f1.requestFocus();
    } on AuthException catch (error) {
      Get.back();
      Get.snackbar("Error", error.message, snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      Get.back();
      Get.snackbar(
        "Error",
        "Error: $error",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
