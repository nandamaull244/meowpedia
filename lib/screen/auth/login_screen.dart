import 'package:flutter/material.dart';
import 'package:meowmedia/navigation/main_navigation.dart';
import 'package:meowmedia/screen/auth/register_screen.dart';
import 'package:meowmedia/service/auth_service.dart';
import '../../widget/auth_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Sign in to continue to MeowMedia',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),

              const SizedBox(height: 32),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthLabel(text: 'Username'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _usernameController,
                    hint: 'Vinna123',
                  ),
                  const SizedBox(height: 20),
                  AuthLabel(text: 'Password'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _passwordController,
                    hint: '******',
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              AuthButton(
                text: 'Log In',
                onPressed: () async {
                  try {
                    await _authService.login(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MainNavigation()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
              ),

              // AuthButton(
              //   text: 'Log In',
              //   onPressed: () {
              //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainNavigation()));
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthLabel(text: "Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()));
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
