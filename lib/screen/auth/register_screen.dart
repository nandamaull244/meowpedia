import 'package:flutter/material.dart';
import 'package:meowmedia/model/user_model.dart';
import 'package:meowmedia/screen/auth/login_screen.dart';
import 'package:meowmedia/service/auth_service.dart';
import 'package:meowmedia/widget/auth_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  DateTime? _selectedDate;
  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _registerUser() async {
    if (_selectedDate == null) return;

    final user = UserModel(
      fullName: _fullNameController.text,
      username: _usernameController.text,
      dateOfBirth: _selectedDate!,
    );

    try {
      await _authService.register(
        user: user,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register berhasil')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

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
                'Join MeowMedia',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Create an account to get starter!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),

              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthLabel(text: 'Full Name'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _fullNameController,
                    hint: 'vinna asomethink jr',
                  ),
                  const SizedBox(height: 20),
                  AuthLabel(text: 'Username'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _usernameController,
                    hint: 'vinna321',
                  ),
                  const SizedBox(height: 20),
                  AuthLabel(text: 'Date of Birth'),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: _dateController,
                    hint: 'DD/MM/YYYY',
                    readOnly: true,
                    obscure: false,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    keyboardType: TextInputType.datetime,
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
                text: 'Sign Up',
                onPressed: () {
                  _registerUser();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthLabel(text: "Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()));
                    },
                    child: const Text('Sign In'),
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
