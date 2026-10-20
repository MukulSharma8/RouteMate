
import 'package:flutter/material.dart';
import 'package:routemate/screens/home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  static const blue = Color(0xFF2563EB);
  static const background = Color(0xFFF8FAFC);
  static const textColor = Color(0xFF0F172A);
  static const secondaryText = Color(0xFF64748B);
  static const borderColor = Color(0xFFE2E8F0);

  void login() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
  }

  void signInWithGoogle() {
    // TODO: Implement Google authentication.
  }

  void forgotPassword() {
    // TODO: Open the forgot password screen.
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Back button
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, size: 21),
                ),
              ),

              const SizedBox(height: 32),

              // RouteMate logo placeholder
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF008FEB),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.route,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(height: 24),

              // Heading
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  letterSpacing: -0.7,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Log in to pick up where your routes left off.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 32),

              // Email field
              _buildTextField(
                controller: emailController,
                hint: 'Email address',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 12),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _inputDecoration(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: forgotPassword,
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Login button
              _primaryButton(
                label: 'Log in',
                onPressed: login,
              ),

              const SizedBox(height: 24),

              // Divider
              _divider(),

              const SizedBox(height: 24),

              // Google button
              _googleButton(),

              const SizedBox(height: 28),

              // Navigate to signup
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    const Text(
                      'New to RouteMate? ',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: secondaryText,
        fontSize: 15,
      ),
      prefixIcon: Icon(
        icon,
        size: 21,
        color: const Color(0xFF334155),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 19),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: blue),
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: borderColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: borderColor)),
      ],
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: signInWithGoogle,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: textColor,
          side: const BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons/google_logo.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'Continue with Google',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
