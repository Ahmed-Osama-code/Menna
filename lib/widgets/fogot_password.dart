import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vigil/widgets/otp_verf.dart';
import 'package:vigil/widgets/page_trans.dart';

class ForgotCreateNewPasswordPage extends StatefulWidget {
  final String email;

  const ForgotCreateNewPasswordPage({super.key, required this.email});

  @override
  State<ForgotCreateNewPasswordPage> createState() =>
      _ForgotCreateNewPasswordPageState();
}

class _ForgotCreateNewPasswordPageState
    extends State<ForgotCreateNewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final pass = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pass.length < 6) {
      Get.snackbar(
        "Weak Password",
        "Password must be at least 6 characters.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pass != confirm) {
      Get.snackbar(
        "Not Match",
        "Passwords do not match.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ ADD THIS: Check if password is different from current password
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser != null) {
        // For forgot password, we need to verify the password is different
        // Try a test login to see if they're using the same password
        try {
          await Supabase.instance.client.auth.signInWithPassword(
            email: widget.email.trim(),
            password: pass,
          );
          // If login succeeds, the password is the same as before
          Get.snackbar(
            "Error",
            "New password must be different from your current password.",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        } catch (e) {
          // Password is different (login failed), continue
        }
      }
    } catch (e) {
      // Continue if error checking
    }

    try {
      setState(() => _isLoading = true);

      // Send OTP to user's email
      await Supabase.instance.client.auth.signInWithOtp(
        email: widget.email.trim(),
      );

      setState(() => _isLoading = false);

      Get.snackbar(
        "Success",
        "OTP has been sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
      );

      Navigator.push(
        context,
        smoothTransition(
          OtpVerificationPage(email: widget.email.trim(), newPassword: pass),
        ),
      );
    } on AuthException catch (error) {
      setState(() => _isLoading = false);

      Get.snackbar("Error", error.message, snackPosition: SnackPosition.BOTTOM);
    } catch (error) {
      setState(() => _isLoading = false);

      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const topColor = Color(0xFF64CDC6);
    const bottomColor = Color(0xFF136A88);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
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
                        // ===== TOP ILLUSTRATION =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Image.asset(
                            'assets/images/illustration.png',
                            height: 330,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 18),

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
                                26,
                                34,
                                26,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "Create New Password",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    "Enter new password that must be different from previous used one.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1.25,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 34),

                                  // Password Field
                                  _passwordField(
                                    controller: _passwordController,
                                    hint: "Enter Your Password",
                                    obscure: _obscurePassword,
                                    onToggle: () => setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    }),
                                  ),

                                  const SizedBox(height: 26),

                                  // Confirm Password Field
                                  _passwordField(
                                    controller: _confirmController,
                                    hint: "Confirm Your Password",
                                    obscure: _obscureConfirm,
                                    onToggle: () => setState(() {
                                      _obscureConfirm = !_obscureConfirm;
                                    }),
                                  ),

                                  const SizedBox(height: 34),

                                  SizedBox(
                                    height: 64,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _sendOTP,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0E6E86,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                        elevation: 0,
                                        disabledBackgroundColor:
                                            Colors.grey[400],
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              "Send OTP",
                                              style: TextStyle(
                                                fontSize: 22,
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

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFFCBD5E1),
            size: 25,
          ),
          suffixIcon: IconButton(
            onPressed: onToggle,
            icon: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF0E7490),
              size: 25,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(top: 13, right: 9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF0E7490), width: 1.8),
          ),
        ),
      ),
    );
  }
}
