import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'package:vigil/widgets/user_login.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // same colors as your login screen
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
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/logo.png",
                                width: 100,
                                height: 100,
                              ),
                              const Text(
                                'MindEase',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),

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
                                    "Create Account",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF101828),
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

                                  const SizedBox(height: 22),

                                  _label("Password"),
                                  const SizedBox(height: 10),
                                  _field(
                                    controller: _passwordController,
                                    hint: "Enter Your Password",
                                    prefix: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    obscureText: _obscurePassword,
                                    suffix: IconButton(
                                      onPressed: () => setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      }),
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF136A88),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  _label("Confirm Password"),
                                  const SizedBox(height: 10),
                                  _field(
                                    controller: _confirmPasswordController,
                                    hint: "Enter Password Again",
                                    prefix: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    obscureText: _obscureConfirmPassword,
                                    suffix: IconButton(
                                      onPressed: () => setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      }),
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF136A88),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  _label("Phone"),
                                  const SizedBox(height: 10),
                                  _field(
                                    controller: _phoneController,
                                    hint: "Enter Your Phone",
                                    prefix: const Icon(
                                      Icons.phone_outlined,
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),

                                  const SizedBox(height: 26),

                                  // Sign Up button
                                  SizedBox(
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final email = _emailController.text.trim();
                                        final password = _passwordController.text.trim();
                                        final confirmPassword = _confirmPasswordController.text.trim();
                                        final phone = _phoneController.text.trim();

                                        // Validation
                                        if (email.isEmpty ||
                                            password.isEmpty ||
                                            confirmPassword.isEmpty ||
                                            phone.isEmpty) {
                                          Get.snackbar(
                                            "Error",
                                            "Please fill in all fields",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        if (!email.contains('@')) {
                                          Get.snackbar(
                                            "Error",
                                            "Please enter a valid email",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        if (password.length < 6) {
                                          Get.snackbar(
                                            "Error",
                                            "Password must be at least 6 characters",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        if (password != confirmPassword) {
                                          Get.snackbar(
                                            "Error",
                                            "Passwords do not match",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                          return;
                                        }

                                        try {
                                          // Show loading
                                          Get.dialog(
                                            const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            barrierDismissible: false,
                                          );

                                          final response = await Supabase.instance.client.auth.signUp(
                                            email: email,
                                            password: password,
                                            data: {
                                              'phone': phone,
                                              'full_name': 'New User',
                                              'role': 'main_caregiver',
                                            },
                                          );

                                          Get.back(); // Close loading

                                          Get.snackbar(
                                            "Success",
                                            "Account created successfully!",
                                            snackPosition: SnackPosition.BOTTOM,
                                          );

                                          // Navigate to login page
                                          Future.delayed(
                                            const Duration(milliseconds: 500),
                                                () {
                                              Navigator.push(
                                                context,
                                                smoothTransition(
                                                  UserLogin(),
                                                ),
                                              );
                                            },
                                          );
                                        } on AuthException catch (error) {
                                          Get.back();
                                          Get.snackbar(
                                            "Sign Up Failed",
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
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 26),

                                  // Continue With divider
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
                                          "Continue With",
                                          style: TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
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

                                  // Social icons (same idea as login screen)
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
      height: 58, // fixed height to look like the design
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFD0D5DD),
            fontSize: 14,
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
