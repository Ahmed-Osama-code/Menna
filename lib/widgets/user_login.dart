import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vigil/widgets/create_account.dart';
import 'package:vigil/widgets/main_screen.dart';
import 'package:vigil/widgets/page_trans.dart';
import 'package:vigil/widgets/pairing_page.dart';
import '../controllers/ble_controller.dart';
import 'fogot_password.dart' show ForgotCreateNewPasswordPage;

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final BleController controller = Get.put(BleController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            colors: [Color(0xFF64CDC6), Color(0xFF136A88)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ===== TOP LOGO AREA =====
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(bottom: 15),
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

                        // ===== WHITE FORM AREA (fills remaining) =====
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Welcome Back',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF101828),
                                    ),
                                  ),
                                  const SizedBox(height: 40),

                                  const Text('E-mail'),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Your E-mail',
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  const Text('Password'),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Your Password',
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                            !_obscurePassword;
                                          });
                                        },
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                          ),
                                          const Text('Remember Me'),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final email = _emailController.text.trim();

                                          // ✅ Validate email before navigation
                                          if (email.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter your email first'),
                                              ),
                                            );
                                            return;
                                          }

                                          if (!email.contains('@')) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Please enter a valid email'),
                                              ),
                                            );
                                            return;
                                          }

                                          // ✅ Navigate to ForgotPasswordPage (OTP will be sent there)
                                          Navigator.push(
                                            context,
                                            smoothTransition(
                                              ForgotCreateNewPasswordPage(email: email),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Forget Password?',
                                          style: TextStyle(
                                            color: Color(0xFF136A88),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 32),

                                  ElevatedButton(
                                    onPressed: () async {
                                      final email = _emailController.text.trim();
                                      final password = _passwordController.text.trim();

                                      if (email.isEmpty || password.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Please enter email and password')),
                                        );
                                        return;
                                      }

                                      try {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );

                                        final response = await Supabase.instance.client.auth.signInWithPassword(
                                          email: email,
                                          password: password,
                                        );

                                        // Check if profile exists
                                        if (response.user != null) {
                                          final existingProfile = await Supabase.instance.client
                                              .from('profiles')
                                              .select()
                                              .eq('id', response.user!.id)
                                              .maybeSingle();

                                          // If profile doesn't exist, create it
                                          if (existingProfile == null) {
                                            await Supabase.instance.client.from('profiles').insert({
                                              'id': response.user!.id,
                                              'full_name': email.split('@')[0],
                                              'phone': '', // Empty for now, user can update later
                                              'role': 'patient',
                                              'created_at': DateTime.now().toIso8601String(),
                                              'updated_at': DateTime.now().toIso8601String(),
                                            });
                                          }
                                        }

                                        Navigator.pop(context);

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Login successful!')),
                                        );

                                        // Navigate to dashboard/home
                                        Navigator.push(
                                          context,
                                          smoothTransition(MainScreen()),
                                        );

                                      } on AuthException catch (error) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Login failed: ${error.message}')),
                                        );
                                      } catch (error) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error: $error')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF136A88),
                                      foregroundColor: Colors.white,
                                    ),
                                    child:  const Text('Log In'),
                                  ),

                                  const SizedBox(height: 24),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Don\'t Have Account?'),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            smoothTransition(
                                              CreateAccountPage(),
                                            ),
                                          );
                                        },
                                        child: const Text('Create Account'),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 25),

                                  Row(
                                    children: const [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text('Or'),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),

                                  const SizedBox(height: 25),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildSocialButton(
                                        svgPath: 'assets/images/google.svg',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 20),
                                      _buildSocialButton(
                                        svgPath: 'assets/images/facebook.svg',
                                        onTap: () {},
                                      ),
                                      const SizedBox(width: 20),
                                      _buildSocialButton(
                                        svgPath: 'assets/images/x.svg',
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
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

  Widget _buildSocialButton({
    required String svgPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(svgPath, width: 50, height: 50),
    );
  }
}
