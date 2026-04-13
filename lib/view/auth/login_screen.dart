import 'package:flutter/material.dart';
import 'package:trade_x_lite/utils/routes_name.dart';

import '../../res/services/auth_service.dart';
import '../../res/services/login_service.dart';
import '../../utils/components/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> checkAuth() async {
    AuthService authService = AuthService();
    bool isCheck = await authService.authenticateLocally();
    if (isCheck) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.homeScreen,
            (route) => false,
      );
    }
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    LoginService authService = LoginService();

    bool isLogin = await authService.login(
      username: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (isLogin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.homeScreen,
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          const SizedBox(height: 10),

                          Container(
                            height: isSmall ? 50 : 70,
                            width: isSmall ? 50 : 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.candlestick_chart,
                              size: isSmall ? 24 : 32,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            "TradeX Lite",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Enter the next dimension of trading.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),

                          const SizedBox(height: 20),

                          AppTextField(
                            controller: emailController,
                            hint: "Username",
                            icon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter username";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          AppTextField(
                            controller: passwordController,
                            hint: "Password",
                            icon: Icons.lock,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter password";
                              }
                              if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?"),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// 🔥 Login Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: isLoading ? null : handleLogin,
                              child: isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text("Login"),
                            ),
                          ),

                          const SizedBox(height: 16),

                          GestureDetector(
                            onTap: checkAuth,
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 24,
                                  child: Icon(Icons.fingerprint),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Use Biometrics",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}