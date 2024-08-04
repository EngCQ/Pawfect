import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_authentication.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  bool _isPasswordVisible = false; // Flag for toggling password visibility
  bool _isLoading = false; // Flag for loading state
  String? _errorMessage; // Error message for validation

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userAuth = Provider.of<UserAuthentication>(context, listen: false);

      try {
        await userAuth.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );

        if (userAuth.user == null || userAuth.userModel == null) {
          setState(() {
            _errorMessage = 'User not registered in the system.';
          });
        } else {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sign In successful!'),
                  duration:
                      Duration(seconds: 1), // Set the duration for 1 second
                ),
              );

              final role = userAuth.userModel?.role;
              if (role == 'Admin') {
                Navigator.pushReplacementNamed(context, '/adminDashboard');
              } else if (role == 'Seller') {
                Navigator.pushReplacementNamed(context, '/sellerDashboard');
              } else {
                Navigator.pushReplacementNamed(context, '/adopterDashboard');
              }
            });
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color of the screen
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App logo
                  Center(
                    child:
                        Image.asset('assets/logo.png', width: 200, height: 200),
                  ),
                  const SizedBox(height: 24), // Spacing
                  const Center(
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 24), // Spacing
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16), // Spacing
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      errorText: _errorMessage,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // Spacing
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24), // Spacing
                  // Sign In button
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => _signIn(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0583CB),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16), // Spacing
                  // Link to Sign Up screen
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signUp');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
